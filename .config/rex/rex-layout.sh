#!/bin/bash
set -euo pipefail

directory=$(cd -- "$(dirname -- "$0")" && pwd)
case "${1:-}" in
  ''|-h|--help|help)
    printf 'Usage: rex-layout <save|restore>\n\n  save     Replace the saved layout with the current layout.\n  restore  Create missing sessions from the saved layout.\n'
    ;;
  save|restore)
    if [ "$#" -ne 1 ]; then
      printf 'Usage: rex-layout <save|restore>\n' >&2
      exit 1
    fi
    exec /bin/bash "$directory/$1-layout.sh"
    ;;
  *) printf 'Unknown command: %s\nUsage: rex-layout <save|restore>\n' "$1" >&2; exit 1 ;;
esac
