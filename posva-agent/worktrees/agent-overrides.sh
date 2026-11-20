#!/bin/sh
set -eu

if [ "$#" -ne 0 ]; then
  # The initial checkout of a worktree has a null old HEAD.
  [ "$#" -eq 3 ] && [ "$3" = 1 ] || exit 0
  case "$1" in
    ''|*[!0]*) exit 0 ;;
  esac
fi
[ -f .git ] || exit 0

gitdir=$(git rev-parse --path-format=absolute --git-common-dir)
overrides="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)/overrides"
repo=${gitdir%/.git}
home=$(CDPATH='' cd -- "$HOME" && pwd -P)
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
  if [ -e "$name" ] || [ -L "$name" ] || git ls-files --error-unmatch -- "$name" >/dev/null 2>&1; then
    continue
  fi
  if ! grep -qxF "/$name" "$exclude" 2>/dev/null; then
    printf '\n/%s\n' "$name" >> "$exclude"
  fi
  git check-ignore -q -- "$name"
  case "$name" in
    AGENTS.override.md) ln -s "$source" "$name" ;;
    CLAUDE.local.md) (set -C; printf '%s\n' '@AGENTS.override.md' > "$name") ;;
  esac
done
