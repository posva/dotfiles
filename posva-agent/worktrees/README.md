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

`gw` and `gwd` accept `-h` or `--help`. `gw` accepts `-n` or `--no-install`
before or after the branch name. An unknown option shows help and returns an
error. Options are checked before any worktree action, including options after
a branch name.

In the `gw` picker, Enter selects a branch or creates one from the typed name
when nothing matches. Esc cancels.
`gw` keeps an existing upstream that points to another remote or branch.

`gpr` lists open PRs, checks out the selected PR in
`.posva/worktrees/pr-<number>` with `gh pr checkout --worktree`, and enters it.
It installs pnpm dependencies in new worktrees, as `gw` does. Open a PR
worktree again with `gw pr/<number>` or by selecting `pr/<number>`. GitHub CLI
keeps the PR's branch and remote settings. If the worktree already exists,
`gpr` enters it without installing again.
If no PRs are open, `gpr` shows an error.

Run `gwd` from the main worktree to pick a worktree to remove. Enter selects it;
Esc cancels. Inside a linked worktree, `gwd` removes that worktree.

New worktrees install pnpm dependencies automatically when pnpm is available
(requires pnpm 11.23+). Run project builds as needed.

If setup fails, fix the error and retry from the worktree root:

```sh
posva_worktree_setup
```
