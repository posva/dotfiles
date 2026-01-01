# AGENTS.md

Eduardo owns this. Start: say "🤟" + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Agent Protocol

- Contact: Eduardo San Martin Morote (@posva, <posva13@gmail.com>).
- PRs: use `gh pr view/diff` (no URLs).
- “Make a note” => edit AGENTS.md (shortcut; not a blocker). Ignore `CLAUDE.md`.
- Guardrails: use `trash` for deletes.
- Bugs: add regression test when it fits.
- Commits: Conventional Commits (`feat|fix|refactor|build|ci|chore|docs|style|perf|test`).
- Subagents: read `docs/subagent.md`.
- Web: search early; quote exact errors

## Tools

### ~/.claude/bin/browser-tools

- Use to navigate and inspect web pages
- Run without args to see help

## Bash commands

- prefer pnpm over npm or yarn, pick based on lockfile presence
- use `pnpm exec vitest run <test-file>` to run specific tests with vitest

## Code style

- TypeScript
- Vue 3 with composition API
