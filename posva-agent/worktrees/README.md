# Worktrees

```sh
gw my-branch   # Create or enter a worktree
gw             # Pick a branch
gwd my-branch  # Remove a worktree
```

In the `gw` picker, Enter selects a branch or creates one from the typed name
when nothing matches. Esc cancels.

Run `gwd` from the main worktree to pick a worktree to remove. Enter selects it;
Esc cancels. Inside a linked worktree, `gwd` removes that worktree.

New worktrees install pnpm dependencies automatically when pnpm is available
(requires pnpm 11.23+). Run project builds as needed.

If setup fails, fix the error and retry from the worktree root:

```sh
posva_worktree_setup
```
