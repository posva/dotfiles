# zmx — terminal session persistence (the tmux *session* replacement).
# Splits & tabs live in Ghostty's leader (ctrl+b); zmx just keeps shells alive
# across detach/quit. Detach a session with ctrl+\ , reattach with `zs`/`za`.
command -v zmx >/dev/null || return

alias zl='zmx ls'          # list sessions
alias za='zmx attach'      # attach/create by exact name
alias zk='zmx kill'        # kill a session

# zs [name] — attach to a session, or fuzzy-pick (type a new name to create).
zs() {
  emulate -L zsh
  local name=$1
  if [[ -z $name ]] && command -v fzf >/dev/null; then
    name=$(zmx ls --short 2>/dev/null | fzf --prompt='zmx session> ' \
      --print-query --reverse --height=40% \
      --header='enter: attach/create · esc: cancel' | tail -1)
  fi
  [[ -z $name ]] && return 0
  zmx attach "$name"
}

# completion: session names for zs/za/zk, plus zmx's own subcommand completion.
if command -v compdef >/dev/null; then
  _zmx_sessions() { local -a s; s=(${(f)"$(zmx ls --short 2>/dev/null)"}); compadd -a s }
  compdef _zmx_sessions zs za zk
  eval "$(zmx completions zsh 2>/dev/null)" && compdef _zmx zmx 2>/dev/null
fi
