# Worktrees

```sh
gw my-branch   # Create or enter a worktree
gw             # Pick a branch
gwd my-branch  # Remove a worktree
```

New worktrees install pnpm dependencies automatically when pnpm is available
(requires pnpm 11.23+). Run project builds as needed.

If setup fails, fix the error and retry from the worktree root:

```sh
posva_worktree_setup
```
