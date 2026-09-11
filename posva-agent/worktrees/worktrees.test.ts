import { test } from 'node:test'
import assert from 'node:assert/strict'
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, realpathSync, existsSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { spawnSync } from 'node:child_process'

const aliases = fileURLToPath(new URL('../../aliases', import.meta.url))

function fixture({ pnpm = true, project = true, failure = false, workspaceOnly = false } = {}) {
  const root = realpathSync(mkdtempSync(join(tmpdir(), 'gw-test-')))
  const repo = join(root, 'repo with spaces')
  const bin = join(root, 'bin')
  mkdirSync(repo)
  mkdirSync(bin)
  const git = (...args: string[]) => {
    const result = spawnSync('/usr/bin/git', args, { cwd: repo, encoding: 'utf8' })
    assert.equal(result.status, 0, result.stderr)
  }
  git('init', '-b', 'main')
  writeFileSync(join(repo, 'README.md'), 'fixture\n')
  if (workspaceOnly) {
    writeFileSync(join(repo, 'pnpm-workspace.yaml'), 'packages: []\n')
  } else if (project) {
    writeFileSync(join(repo, 'package.json'), '{"private":true}\n')
    writeFileSync(join(repo, 'pnpm-lock.yaml'), 'lockfileVersion: "9.0"\n')
  }
  git('add', '.')
  git('-c', 'user.name=Test', '-c', 'user.email=test@example.com', '-c', 'commit.gpgsign=false', 'commit', '-m', 'fixture')
  mkdirSync(join(repo, 'dist'))
  writeFileSync(join(repo, 'dist', 'stale.js'), 'old build\n')
  if (pnpm) {
    writeFileSync(join(bin, 'pnpm'), '#!/bin/sh\nprintf "%s\\n" "$PWD" "$PNPM_CONFIG_VIRTUAL_STORE_TYPE" "$*" >> "$GW_TEST_LOG"\nexit "${GW_TEST_FAILURE:-0}"\n', { mode: 0o755 })
  }
  const log = join(root, 'install.log')
  const run = (branch: string) => spawnSync('/bin/zsh', ['-f', '-c',
    'source "$1"; export PATH="$2:/usr/bin:/bin"; git_create_worktree "$3"; result=$?; print -r -- "RESULT=$result" "LOCATION=$PWD" "STORE=$PNPM_CONFIG_VIRTUAL_STORE_TYPE"; exit $result',
    'test', aliases, bin, branch,
  ], { cwd: repo, encoding: 'utf8', env: { ...process.env, PNPM_CONFIG_VIRTUAL_STORE_TYPE: 'project', GW_TEST_LOG: log, GW_TEST_FAILURE: failure ? '7' : '0' } })
  const pick = (output: string, status = 0) => {
    writeFileSync(join(bin, 'fzf'), '#!/bin/sh\ncat >/dev/null\nprintf "%s" "$GW_TEST_PICK"\nexit "$GW_TEST_PICK_STATUS"\n', { mode: 0o755 })
    return spawnSync('/bin/zsh', ['-f', '-c',
      'source "$1"; export PATH="$2:/usr/bin:/bin"; git_create_worktree',
      'test', aliases, bin,
    ], { cwd: repo, encoding: 'utf8', env: { ...process.env, GW_TEST_PICK: output, GW_TEST_PICK_STATUS: String(status) } })
  }
  return { repo, log, run, pick }
}

test('picker accepts a branch name', () => {
  const { repo, pick } = fixture({ project: false })
  const result = pick('feature/picked\n')
  assert.equal(result.status, 0, result.stderr)
  assert.ok(existsSync(join(repo, '.posva/worktrees/feature-picked')))
})

for (const status of [1, 2, 130]) {
  test(`picker exit ${status} does not create a worktree from its output`, () => {
    const { repo, pick } = fixture({ project: false })
    assert.notEqual(pick('feature/unwanted\n', status).status, 0)
    assert.equal(existsSync(join(repo, '.posva/worktrees')), false)
  })
}

test('empty picker output does not create a worktree', () => {
  const { repo, pick } = fixture({ project: false })
  assert.notEqual(pick('').status, 0)
  assert.equal(existsSync(join(repo, '.posva/worktrees')), false)
})

test('new pnpm worktree installs with shared store and permits downloads', () => {
  const { repo, log, run } = fixture()
  const result = run('feature/warm')
  assert.equal(result.status, 0, result.stderr)
  assert.equal(readFileSync(log, 'utf8'), `${repo}/.posva/worktrees/feature-warm\nglobal\ninstall --frozen-lockfile\n`)
  assert.match(result.stdout, /ready:/)
  assert.match(result.stdout, /STORE=project/)
  assert.equal(existsSync(join(repo, '.posva/worktrees/feature-warm/dist')), false)
  assert.equal(run('feature/warm').status, 0)
  assert.equal(readFileSync(log, 'utf8').split('\n').length, 4)
})

test('failed install keeps the worktree and reports failure', () => {
  const { repo, run } = fixture({ failure: true })
  const result = run('failed')
  assert.equal(result.status, 7)
  assert.ok(result.stdout.includes(`LOCATION=${repo}/.posva/worktrees/failed`))
  assert.doesNotMatch(result.stdout, /ready:/)
})

test('missing pnpm skips setup with a message', () => {
  const result = fixture({ pnpm: false }).run('no-pnpm')
  assert.equal(result.status, 0, result.stderr)
  assert.match(result.stdout, /pnpm.*not found/)
})

test('other repositories skip pnpm setup', () => {
  const { log, run } = fixture({ project: false })
  const result = run('plain')
  assert.equal(result.status, 0, result.stderr)
  assert.throws(() => readFileSync(log), { code: 'ENOENT' })
})

test('workspace roots without a package.json still get setup', () => {
  const { log, run } = fixture({ workspaceOnly: true })
  const result = run('workspace')
  assert.equal(result.status, 0, result.stderr)
  assert.match(readFileSync(log, 'utf8'), /install --frozen-lockfile/)
})

test('failed worktree creation does not install or change directory', () => {
  const { repo, log, run } = fixture()
  const result = run('bad..branch')
  assert.notEqual(result.status, 0)
  assert.ok(result.stdout.includes(`LOCATION=${repo} STORE=`), result.stdout)
  assert.equal(existsSync(log), false)
  assert.doesNotMatch(result.stdout, /ready:/)
})
