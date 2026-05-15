#!/bin/bash
# Terminal control for Claude Code hooks.
# Sets titles, sends desktop notifications, and shows a progress indicator.
#
# Hooks run without a controlling tty, so writing to /dev/tty silently fails.
# We walk the parent process tree to find claude's real pty and write there.
# Inside tmux we wrap sequences in DCS passthrough so the outer terminal sees them
# (requires `set -g allow-passthrough on` in tmux.conf for notify/progress).
#
# Usage:
#   set-title.sh title <text>
#   set-title.sh notify <title> [body]
#   set-title.sh progress <state> [value]   # state: 0=clear 1=normal 2=error 3=indeterminate 4=paused
#   set-title.sh <text>                      # legacy: same as `title <text>`

set -u

find_tty() {
  local pid=${PPID:-$$} hops=0 line tty parent
  while [ "$hops" -lt 10 ] && [ -n "$pid" ] && [ "$pid" != "1" ] && [ "$pid" != "0" ]; do
    line=$(ps -o tty=,ppid= -p "$pid" 2>/dev/null) || return 1
    tty=$(echo "$line" | awk '{print $1}')
    parent=$(echo "$line" | awk '{print $2}')
    case "$tty" in
      ''|'?'|'??') ;;
      *) echo "/dev/$tty"; return 0 ;;
    esac
    pid=$parent
    hops=$((hops + 1))
  done
  return 1
}

emit() {
  local seq=$1 tty
  tty=$(find_tty) || return 0

  if [ -n "${TMUX:-}" ]; then
    # tmux DCS passthrough: ESC inside the wrapped payload must be doubled.
    local doubled
    doubled=$(printf '%s' "$seq" | sed $'s/\033/\033\033/g')
    printf '\033Ptmux;%s\033\\' "$doubled" > "$tty" 2>/dev/null
  else
    printf '%s' "$seq" > "$tty" 2>/dev/null
  fi
}

set_title() {
  local text=$1
  # OSC 0 sets both icon name and window title; widely supported.
  emit "$(printf '\033]0;%s\007' "$text")"
  # Also set the tmux window name when applicable so the tmux status line updates.
  if [ -n "${TMUX:-}" ]; then
    local tty
    tty=$(find_tty) && printf '\033k%s\033\\' "$text" > "$tty" 2>/dev/null
  fi
}

notify() {
  local title=$1 body=${2:-$1}
  # OSC 777 is the recommended cross-terminal notification sequence (Ghostty, urxvt-style).
  emit "$(printf '\033]777;notify;%s;%s\007' "$title" "$body")"
  # Inside tmux a bare BEL trips monitor-bell so the window gets flagged in the status line.
  if [ -n "${TMUX:-}" ]; then
    local tty
    tty=$(find_tty) && printf '\007' > "$tty" 2>/dev/null
  fi
}

progress() {
  local state=${1:-0} value=${2:-}
  if [ -n "$value" ]; then
    emit "$(printf '\033]9;4;%s;%s\007' "$state" "$value")"
  else
    emit "$(printf '\033]9;4;%s\007' "$state")"
  fi
}

cmd=${1:-}
case "$cmd" in
  title)    set_title "${2:-}" ;;
  notify)   notify "${2:-}" "${3:-}" ;;
  progress) progress "${2:-0}" "${3:-}" ;;
  '')       ;;
  *)        set_title "$cmd" ;;  # legacy single-arg form
esac
