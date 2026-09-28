# Worktrees

```sh
gw my-branch   # Create or enter a worktree
gw             # Pick a branch
gw -n my-branch  # Create a worktree without installing pnpm dependencies
gw -n            # Pick a branch without installing pnpm dependencies
gpr              # Pick a PR and open it in a worktree
gwd my-branch  # Remove a worktree
gw --help     # Show help for gw
gwd --help    # Show help for gwd
```

Both commands accept `-h` or `--help`. `gw` accepts `-n` or `--no-install`
before or after the branch name. An unknown option shows help and returns an
error. Options are checked before any worktree action, including options after
a branch name.

In the `gw` picker, Enter selects a branch or creates one from the typed name
when nothing matches. Esc cancels.

`gpr` lists open PRs, checks out the selected PR in
`.posva/worktrees/pr-<number>` with `gh pr checkout --worktree`, and enters it.
If the worktree already exists, `gpr` enters it.

Run `gwd` from the main worktree to pick a worktree to remove. Enter selects it;
Esc cancels. Inside a linked worktree, `gwd` removes that worktree.

New worktrees install pnpm dependencies automatically when pnpm is available
(requires pnpm 11.23+). Run project builds as needed.

If setup fails, fix the error and retry from the worktree root:

```sh
posva_worktree_setup
```
