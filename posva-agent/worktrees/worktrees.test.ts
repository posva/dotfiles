import { test } from 'node:test'
import assert from 'node:assert/strict'
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, realpathSync, existsSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { spawnSync } from 'node:child_process'

const aliases = fileURLToPath(new URL('../../aliases', import.meta.url))

// User hooks and push defaults must not affect the fixtures.
process.env.GIT_CONFIG_GLOBAL = '/dev/null'
process.env.GIT_CONFIG_NOSYSTEM = '1'

for (const command of ['gw', 'gwd']) {
  for (const option of ['-h', '--help', '-x', '--unknown']) {
    for (const args of [[option], ['feature/example', option]]) {
      test(`${command} ${args.join(' ')} shows help before any work`, () => {
        const root = realpathSync(mkdtempSync(join(tmpdir(), 'gw-help-test-')))
        const result = spawnSync('/bin/zsh', ['-f', '-c',
          'source "$1"; shift; function git() { print -u2 -- "unexpected git call"; return 99 }; function fzf() { print -u2 -- "unexpected fzf call"; return 99 }; command_name=$1; shift; eval "$command_name" \'"$@"\'',
          'test', aliases, command, ...args,
        ], { cwd: root, encoding: 'utf8' })
        const help = option === '-h' || option === '--help'
        assert.equal(result.status, help ? 0 : 2, result.stderr)
        const output = result.stdout + result.stderr
        const usage = command === 'gw' ? 'Usage: gw [-n|--no-install] [branch]' : 'Usage: gwd [branch]'
        assert.ok(output.includes(usage), output)
        assert.match(output, /-h, --help/)
        assert.doesNotMatch(output, /unexpected (git|fzf) call/)
        if (!help) assert.ok(result.stderr.includes(`Unknown option: ${option}`), result.stderr)
      })
    }
  }
}

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
    writeFileSync(join(bin, 'pnpm'), String.raw`#!/bin/sh
printf '%s\n' "$PWD" >> "$GW_TEST_LOG"
[ -z "$GW_TEST_FAILURE" ] || [ "$GW_TEST_FAILURE" = 0 ] || exit "$GW_TEST_FAILURE"
mkdir -p node_modules
printf '%s\n' "$PNPM_CONFIG_VIRTUAL_STORE_TYPE" > node_modules/.store-type
`, { mode: 0o755 })
  }
  const log = join(root, 'install.log')
  const run = (...args: string[]) => spawnSync('/bin/zsh', ['-f', '-c',
    'source "$1"; export PATH="$2:/usr/bin:/bin"; shift 2; git_create_worktree "$@"; result=$?; print -r -- "RESULT=$result" "LOCATION=$PWD" "STORE=$PNPM_CONFIG_VIRTUAL_STORE_TYPE"; exit $result',
    'test', aliases, bin, ...args,
  ], { cwd: repo, encoding: 'utf8', env: { ...process.env, PNPM_CONFIG_VIRTUAL_STORE_TYPE: 'project', GW_TEST_LOG: log, GW_TEST_FAILURE: failure ? '7' : '0' } })
  const pick = (output: string, status = 0, ...args: string[]) => {
    writeFileSync(join(bin, 'fzf'), '#!/bin/sh\ncat >/dev/null\nprintf "%s" "$GW_TEST_PICK"\nexit "$GW_TEST_PICK_STATUS"\n', { mode: 0o755 })
    return spawnSync('/bin/zsh', ['-f', '-c',
      'source "$1"; export PATH="$2:/usr/bin:/bin"; shift 2; git_create_worktree "$@"',
      'test', aliases, bin, ...args,
    ], { cwd: repo, encoding: 'utf8', env: { ...process.env, GW_TEST_PICK: output, GW_TEST_PICK_STATUS: String(status) } })
  }
  return { repo, bin, log, run, pick }
}

function prFixture({ failure = false, fork = false, remoteUrl = false } = {}) {
  const { repo, bin, log, run: branchRun } = fixture({ failure })
  const forkPath = join(dirname(repo), 'fork.git')
  const basePath = join(dirname(repo), 'base.git')
  if (fork) {
    for (const path of [basePath, forkPath]) {
      const init = spawnSync('/usr/bin/git', ['init', '--bare', path], { cwd: repo, encoding: 'utf8' })
      assert.equal(init.status, 0, init.stderr)
      const push = spawnSync('/usr/bin/git', ['push', path, 'HEAD:refs/heads/feature/fix'], { cwd: repo, encoding: 'utf8' })
      assert.equal(push.status, 0, push.stderr)
    }
    const add = spawnSync('/usr/bin/git', ['remote', 'add', 'origin', basePath], { cwd: repo, encoding: 'utf8' })
    assert.equal(add.status, 0, add.stderr)
    const fetch = spawnSync('/usr/bin/git', ['fetch', 'origin'], { cwd: repo, encoding: 'utf8' })
    assert.equal(fetch.status, 0, fetch.stderr)
  }
  writeFileSync(join(bin, 'gh'), String.raw`#!/bin/sh
if [ "$1" = pr ] && [ "$2" = list ]; then
  [ "$GW_TEST_EMPTY_LIST" = 1 ] && exit 0
  printf '42\tFix a bug\tfeature/fix\n'
  exit 0
fi
if [ "$1" = pr ] && [ "$2" = checkout ]; then
  [ "$GW_TEST_CHECKOUT_STATUS" = 0 ] || exit "$GW_TEST_CHECKOUT_STATUS"
  number=$3
  shift 3
  branch=feature/fix
  [ "$1" = --worktree ] || exit 2
  target=$2
  if [ -n "$GW_TEST_FORK_PATH" ]; then
    /usr/bin/git remote add contributor "$GW_TEST_FORK_PATH" || exit $?
    /usr/bin/git fetch contributor || exit $?
    /usr/bin/git worktree add -b "$branch" "$target" contributor/feature/fix || exit $?
    /usr/bin/git -C "$target" branch --set-upstream-to=contributor/feature/fix "$branch" || exit $?
    if [ "$GW_TEST_REMOTE_URL" = 1 ]; then
      /usr/bin/git config "branch.$branch.remote" "$GW_TEST_FORK_PATH" || exit $?
      /usr/bin/git config "branch.$branch.pushRemote" "$GW_TEST_FORK_PATH" || exit $?
      /usr/bin/git config remote.pushDefault origin || exit $?
    fi
  else
    /usr/bin/git worktree add -b "$branch" "$target" || exit $?
  fi
  printf '%s\n' "$number" > "$target/.pr-number"
  exit 0
fi
exit 2
`, { mode: 0o755 })
  writeFileSync(join(bin, 'fzf'), String.raw`#!/bin/sh
input=$(cat)
[ -n "$input" ] || exit 1
[ "$GW_TEST_PICK_STATUS" = 0 ] || exit "$GW_TEST_PICK_STATUS"
if [ "$GW_TEST_PICK_WORKTREE" = 1 ]; then
  printf '%s\n' "$input" | /usr/bin/grep -qx 'pr/42' || exit 1
  printf 'pr/42\n'
  exit 0
fi
printf '42\tFix a bug\tfeature/fix\n'
`, { mode: 0o755 })
  const run = (pickStatus = 0, checkoutStatus = 0, emptyList = false) => spawnSync('/bin/zsh', ['-f', '-c',
    'source "$1"; export PATH="$2:/usr/bin:/bin"; eval gpr; result=$?; print -r -- "LOCATION=$PWD"; exit $result',
    'test', aliases, bin,
  ], { cwd: repo, encoding: 'utf8', env: { ...process.env, GW_TEST_LOG: log, GW_TEST_PICK_STATUS: String(pickStatus), GW_TEST_CHECKOUT_STATUS: String(checkoutStatus), GW_TEST_EMPTY_LIST: emptyList ? '1' : '0', GW_TEST_FAILURE: failure ? '7' : '0', GW_TEST_FORK_PATH: fork ? forkPath : '', GW_TEST_REMOTE_URL: remoteUrl ? '1' : '0' } })
  const runGw = () => spawnSync('/bin/zsh', ['-f', '-c',
    'source "$1"; export PATH="$2:/usr/bin:/bin"; eval gw; result=$?; print -r -- "LOCATION=$PWD"; exit $result',
    'test', aliases, bin,
  ], { cwd: repo, encoding: 'utf8', env: { ...process.env, GW_TEST_LOG: log, GW_TEST_PICK_STATUS: '0', GW_TEST_PICK_WORKTREE: '1' } })
  return { repo, log, run, runGw, branchRun, forkPath, basePath }
}

test('gpr installs dependencies, and gw finds the PR in a new shell', () => {
  const { repo, log, run, runGw } = prFixture()
  const target = join(repo, '.posva/worktrees/pr-42')
  const result = run()
  assert.equal(result.status, 0, result.stderr)
  assert.ok(result.stdout.includes(`LOCATION=${target}`), result.stdout)
  assert.equal(readFileSync(join(target, '.pr-number'), 'utf8'), '42\n')
  assert.equal(spawnSync('/usr/bin/git', ['branch', '--show-current'], { cwd: repo, encoding: 'utf8' }).stdout.trim(), 'main')
  assert.equal(spawnSync('/usr/bin/git', ['branch', '--show-current'], { cwd: target, encoding: 'utf8' }).stdout.trim(), 'feature/fix')
  const installLog = readFileSync(log, 'utf8')
  assert.equal(installLog, `${target}\n`)
  assert.equal(readFileSync(join(target, 'node_modules/.store-type'), 'utf8'), 'global\n')
  const second = run()
  assert.equal(second.status, 0, second.stderr)
  assert.ok(second.stdout.includes(`LOCATION=${target}`), second.stdout)
  const gw = runGw()
  assert.equal(gw.status, 0, gw.stderr)
  assert.ok(gw.stdout.includes(`LOCATION=${target}`), gw.stdout)
  assert.equal(readFileSync(log, 'utf8'), installLog)
})

for (const remoteUrl of [false, true]) {
  test(`gpr preserves pushes to a fork ${remoteUrl ? 'URL' : 'remote'} after reopening`, () => {
    const { repo, run, runGw, branchRun, forkPath, basePath } = prFixture({ fork: true, remoteUrl })
    const target = join(repo, '.posva/worktrees/pr-42')
    const checkout = run()
    assert.equal(checkout.status, 0, checkout.stderr)
    const reopened = run()
    assert.equal(reopened.status, 0, reopened.stderr)
    const byBranch = branchRun('feature/fix')
    assert.equal(byBranch.status, 0, byBranch.stderr)
    const entered = runGw()
    assert.equal(entered.status, 0, entered.stderr)
    assert.ok(entered.stdout.includes(`LOCATION=${target}`), entered.stdout)
    writeFileSync(join(target, 'pushed.txt'), 'PR change\n')
    for (const args of [
      ['-C', target, 'add', 'pushed.txt'],
      ['-C', target, '-c', 'user.name=Test', '-c', 'user.email=test@example.com', '-c', 'commit.gpgsign=false', 'commit', '-m', 'PR change'],
    ]) {
      const result = spawnSync('/usr/bin/git', args, { encoding: 'utf8' })
      assert.equal(result.status, 0, result.stderr)
    }
    const pushed = spawnSync('/usr/bin/git', ['-C', target, '-c', 'push.default=simple', 'push'], { encoding: 'utf8' })
    assert.equal(pushed.status, 0, pushed.stderr)
    const head = spawnSync('/usr/bin/git', ['-C', target, 'rev-parse', 'HEAD'], { encoding: 'utf8' }).stdout.trim()
    const forkHead = spawnSync('/usr/bin/git', ['--git-dir', forkPath, 'rev-parse', 'refs/heads/feature/fix'], { encoding: 'utf8' }).stdout.trim()
    const baseHead = spawnSync('/usr/bin/git', ['--git-dir', basePath, 'rev-parse', 'refs/heads/feature/fix'], { encoding: 'utf8' }).stdout.trim()
    assert.equal(forkHead, head)
    assert.notEqual(baseHead, head)
  })
}

test('gpr rejects a directory that is not a registered PR worktree', () => {
  const { repo, run, branchRun } = prFixture()
  const other = branchRun('pr/42', '--no-install')
  assert.equal(other.status, 0, other.stderr)
  const target = join(repo, '.posva/worktrees/pr-42')
  const moved = spawnSync('/usr/bin/git', ['worktree', 'move', target, join(repo, 'other')], { cwd: repo, encoding: 'utf8' })
  assert.equal(moved.status, 0, moved.stderr)
  mkdirSync(target)
  writeFileSync(join(target, 'keep.txt'), 'keep me\n')

  const result = run()

  assert.notEqual(result.status, 0)
  assert.ok(result.stdout.includes(`LOCATION=${repo}`), result.stdout)
  assert.equal(readFileSync(join(target, 'keep.txt'), 'utf8'), 'keep me\n')
})

test('gpr keeps the worktree when pnpm setup fails', () => {
  const { repo, run } = prFixture({ failure: true })
  const target = join(repo, '.posva/worktrees/pr-42')
  const result = run()
  assert.equal(result.status, 7)
  assert.ok(result.stdout.includes(`LOCATION=${target}`), result.stdout)
  assert.ok(existsSync(join(target, '.pr-number')))
  assert.doesNotMatch(result.stdout, /ready:/)
})

for (const detached of [false, true]) {
  test(`gw finds an existing ${detached ? 'detached' : 'branch'} PR worktree by its PR number`, () => {
    const { repo, run, runGw } = prFixture()
    const target = join(repo, '.posva/worktrees/pr-42')
    const args = detached ? ['worktree', 'add', '--detach', target] : ['worktree', 'add', '-b', 'feature/fix', target]
    const created = spawnSync('/usr/bin/git', args, { cwd: repo, encoding: 'utf8' })
    assert.equal(created.status, 0, created.stderr)
    const selected = runGw()
    assert.equal(selected.status, 0, selected.stderr)
    assert.ok(selected.stdout.includes(`LOCATION=${target}`), selected.stdout)
    const reopened = run()
    assert.equal(reopened.status, 0, reopened.stderr)
    assert.ok(reopened.stdout.includes(`LOCATION=${target}`), reopened.stdout)
  })
}

test('gpr leaves the current worktree alone when selection is canceled', () => {
  const { repo, log, run } = prFixture()
  const result = run(130)
  assert.equal(result.status, 130)
  assert.ok(result.stdout.includes(`LOCATION=${repo}`), result.stdout)
  assert.equal(existsSync(join(repo, '.posva/worktrees/pr-42')), false)
  assert.equal(existsSync(log), false)
})

test('gpr leaves the current worktree alone when PR checkout fails', () => {
  const { repo, log, run } = prFixture()
  const result = run(0, 7)
  assert.equal(result.status, 7)
  assert.ok(result.stdout.includes(`LOCATION=${repo}`), result.stdout)
  assert.equal(existsSync(join(repo, '.posva/worktrees/pr-42')), false)
  assert.equal(existsSync(log), false)
})

test('gpr reports when there are no open PRs', () => {
  const { repo, log, run } = prFixture()
  const result = run(0, 0, true)
  assert.equal(result.status, 1)
  assert.match(result.stderr, /No open PRs found/)
  assert.ok(result.stdout.includes(`LOCATION=${repo}`), result.stdout)
  assert.equal(existsSync(join(repo, '.posva/worktrees')), false)
  assert.equal(existsSync(log), false)
})

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

test('new pnpm worktree installs once with shared store', () => {
  const { repo, log, run } = fixture()
  const result = run('feature/warm')
  assert.equal(result.status, 0, result.stderr)
  assert.equal(readFileSync(log, 'utf8'), `${repo}/.posva/worktrees/feature-warm\n`)
  assert.match(result.stdout, /ready:/)
  assert.match(result.stdout, /STORE=project/)
  assert.equal(readFileSync(join(repo, '.posva/worktrees/feature-warm/node_modules/.store-type'), 'utf8'), 'global\n')
  assert.equal(existsSync(join(repo, '.posva/worktrees/feature-warm/dist')), false)
  assert.equal(run('feature/warm').status, 0)
  assert.equal(readFileSync(log, 'utf8'), `${repo}/.posva/worktrees/feature-warm\n`)
})

for (const args of [
  ['--no-install', 'feature/skip'],
  ['feature/skip', '--no-install'],
  ['-n', 'feature/skip'],
  ['feature/skip', '-n'],
]) {
  test(`gw ${args.join(' ')} creates a worktree without installing`, () => {
    const { repo, log, run } = fixture({ failure: true })
    const result = run(...args)
    assert.equal(result.status, 0, result.stderr)
    assert.ok(existsSync(join(repo, '.posva/worktrees/feature-skip/pnpm-lock.yaml')))
    assert.equal(existsSync(log), false)
    assert.match(result.stdout, /ready:/)
    assert.match(result.stdout, /STORE=project/)
  })
}

for (const option of ['-n', '--no-install']) {
  test(`gw ${option} works with the branch picker`, () => {
    const { repo, log, pick } = fixture()
    const result = pick('feature/picked\n', 0, option)
    assert.equal(result.status, 0, result.stderr)
    assert.ok(existsSync(join(repo, '.posva/worktrees/feature-picked/pnpm-lock.yaml')))
    assert.equal(existsSync(log), false)
  })
}

test('existing worktree enters a local branch when its remote branch is missing', () => {
  const { repo, run } = fixture({ project: false })
  assert.equal(run('feature/stale').status, 0)
  const worktree = join(repo, '.posva/worktrees/feature-stale')
  const git = (...args: string[]) => spawnSync('/usr/bin/git', args, { cwd: worktree, encoding: 'utf8' })
  assert.equal(git('config', 'branch.feature/stale.remote', 'origin').status, 0)
  assert.equal(git('config', 'branch.feature/stale.merge', 'refs/heads/feature/stale').status, 0)

  const result = run('feature/stale')

  assert.equal(result.status, 0, result.stderr)
  assert.match(result.stdout, /remote branch origin\/feature\/stale is missing; using local branch without upstream/)
  assert.match(result.stdout, new RegExp(`LOCATION=${worktree}`))
  assert.doesNotMatch(git('status', '--short', '--branch').stdout, /\[gone\]/)
})

for (const branch of ['feature/tracked', 'pr/42', 'pr-42']) {
  test(`existing ${branch} worktree tracks its matching remote branch when it exists`, () => {
    const { repo, run } = fixture({ project: false })
    assert.equal(run(branch).status, 0)
    const worktree = join(repo, '.posva/worktrees', branch.replaceAll('/', '-'))
    const git = (...args: string[]) => spawnSync('/usr/bin/git', args, { cwd: worktree, encoding: 'utf8' })
    assert.equal(git('config', 'remote.origin.url', 'git@example.com:owner/repo.git').status, 0)
    assert.equal(git('config', 'remote.origin.fetch', '+refs/heads/*:refs/remotes/origin/*').status, 0)
    assert.equal(git('update-ref', `refs/remotes/origin/${branch}`, 'HEAD').status, 0)

    const result = run(branch)

    assert.equal(result.status, 0, result.stderr)
    assert.equal(git('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{upstream}').stdout.trim(), `origin/${branch}`)
    assert.doesNotMatch(result.stdout, /remote branch .* is missing/)
  })
}

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
  const { repo, run } = fixture({ workspaceOnly: true })
  const result = run('workspace')
  assert.equal(result.status, 0, result.stderr)
  assert.ok(existsSync(join(repo, '.posva/worktrees/workspace/node_modules')))
})

test('failed worktree creation does not install or change directory', () => {
  const { repo, log, run } = fixture()
  const result = run('bad..branch')
  assert.notEqual(result.status, 0)
  assert.ok(result.stdout.includes(`LOCATION=${repo} STORE=`), result.stdout)
  assert.equal(existsSync(log), false)
  assert.doesNotMatch(result.stdout, /ready:/)
})
