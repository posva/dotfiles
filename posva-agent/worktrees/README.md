# Worktrees

```sh
gw my-branch   # Create or enter a worktree
gw             # Pick a branch
gw -n my-branch  # Create a worktree without installing pnpm dependencies
gw -n            # Pick a branch without installing pnpm dependencies
gpr              # Pick a PR and open it in a worktree
gwd my-branch  # Remove a worktree and delete its merged local branch
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
If no worktree has the requested branch, `gw` also checks its usual folder
in `.posva/worktrees`. If that folder is a registered worktree, `gw` enters it.
It shows a ⚠ warning if the current branch differs from the requested name
and keeps the current branch and upstream settings.

`gpr` lists open PRs, checks out the selected PR in
`.posva/worktrees/pr-<number>` with `gh pr checkout --worktree`, and enters it.
It installs pnpm dependencies in new worktrees, as `gw` does. Open a PR
worktree again with `gw pr/<number>` or by selecting `pr/<number>`. GitHub CLI
keeps the PR's branch and remote settings. If the worktree already exists,
`gpr` enters it without installing again.
If no PRs are open, `gpr` shows an error.

Run `gwd` from the main worktree to pick a worktree to remove. Enter selects it;
Esc cancels. Inside a linked worktree, `gwd` removes that worktree.
After removal, `gwd` deletes its local branch with `git branch -d`. Git checks
whether the branch is merged into its upstream, or into the main worktree's
current branch if no upstream is set. If Git refuses deletion, `gwd` keeps the
branch, shows a warning, and returns an error. A detached worktree has no branch
to delete.

To clean up other branches, update remote references and list branches merged
into `main` (use your repository's default branch if different):

```sh
git fetch --prune
git branch --merged main
git branch -d branch-name
```

Select branches from the list and delete them with `git branch -d`. Keep `main`
and any branch you still use. `git fetch --prune` removes references to deleted
remote branches; it keeps local branches. After a squash merge, Git can refuse
`-d` because the original commits are not in the merge history. Use
`git branch -D branch-name` only after you check that its changes are saved.
If a worktree directory was deleted outside Git, `git worktree prune` removes
its stale worktree record; it keeps the local branch.

New worktrees install pnpm dependencies automatically when pnpm is available
(requires pnpm 11.23+). Run project builds as needed.

If setup fails, fix the error and retry from the worktree root:

```sh
posva_worktree_setup
```
