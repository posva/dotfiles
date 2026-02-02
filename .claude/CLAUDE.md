# AGENTS.md

Eduardo owns this. Start: say "🤟" + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Agent Protocol

- Contact: Eduardo San Martin Morote (@posva, <posva13@gmail.com>).
- PRs: use `gh pr view/diff` (no URLs).
- “Make a note” => edit AGENTS.md (shortcut; not a blocker). Ignore `CLAUDE.md`.
- Guardrails: use `trash` for deletes.
- Bugs: add regression test when it fits.
- Commits: Conventional Commits (`feat|fix|refactor|build|ci|chore|docs|style|perf|test`).
- Web: search early; quote exact errors

## Tools

### Browser Automation

Use `agent-browser` for web automation. Run `agent-browser --help` for all commands.

Core workflow:

1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. `agent-browser click @e1` / `fill @e2 "text"` - Interact using refs
4. Re-snapshot after page changes

## Bash commands

- prefer pnpm over npm or yarn, pick based on lockfile presence
- use `pnpm exec vitest run <test-file>` to run specific tests with vitest

## Code style

- TypeScript
- Vue 3 with composition API
- Use `node` to run TS directly
- Always use ESM, never CJS

