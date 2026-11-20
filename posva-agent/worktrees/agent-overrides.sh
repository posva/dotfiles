#!/bin/sh
# Run from a linked worktree root, directly or as a post-checkout hook.
# Link the repo's shared Codex override and generate its Claude Code import.
set -eu

if [ "$#" -ne 0 ]; then
  # Git passes old HEAD, new HEAD, and 1 for a branch checkout.
  # A new worktree has an all-zero old HEAD.
  [ "$#" -eq 3 ] && [ "$3" = 1 ] || exit 0
  # Skip empty IDs and IDs with any nonzero character.
  case "$1" in
    ''|*[!0]*) exit 0 ;;
  esac
fi
# Linked worktrees use a .git file that points to their Git metadata.
[ -f .git ] || exit 0

# Use the shared Git directory so all worktrees find the same override.
gitdir=$(git rev-parse --path-format=absolute --git-common-dir)
overrides="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)/overrides"
repo=${gitdir%/.git}
home=$(CDPATH='' cd -- "$HOME" && pwd -P)
# Strip the home directory prefix for repos under ~.
case "$repo" in
  "$home") path= ;;
  "$home"/*) path=${repo#"$home"} ;;
  *) path=$repo ;;
esac
source="$overrides$path/AGENTS.override.md"
[ -f "$source" ] || exit 0

exclude="$gitdir/info/exclude"
mkdir -p "$gitdir/info"
for name in AGENTS.override.md CLAUDE.local.md; do
  # Preserve tracked paths and existing files, including dangling symlinks.
  if [ -e "$name" ] || [ -L "$name" ] || git ls-files --error-unmatch -- "$name" >/dev/null 2>&1; then
    continue
  fi
  if ! grep -qxF "/$name" "$exclude" 2>/dev/null; then
    printf '\n/%s\n' "$name" >> "$exclude"
  fi
  git check-ignore -q -- "$name"
  case "$name" in
    AGENTS.override.md) ln -s "$source" "$name" ;;
    # Noclobber (set -C) protects a file created after the existence check.
    CLAUDE.local.md) (set -C; printf '%s\n' '@AGENTS.override.md' > "$name") ;;
  esac
done
