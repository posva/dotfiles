#!/bin/bash
# Set terminal title with appropriate escape sequence
# Usage: set-title.sh <title>

title="$1"

if [ -n "$TMUX" ]; then
  # tmux/screen escape sequence
  printf '\033k%s\033\\' "$title" > /dev/tty
else
  # OSC escape sequence for regular terminals (ghostty, iTerm2, etc.)
  printf '\033]0;%s\007' "$title" > /dev/tty
fi
