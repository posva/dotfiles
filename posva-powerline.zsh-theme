# Theme by Eduardo San Martin Morote aka Posva
# http://posva.github.io
# Use as you wish but don't remove this notice
# Sat May 18 16:30:33 CEST 2013 

# Powerline sep ❯
SEP=""
SEP="❯"

CURRENT_BG='NONE'
PRIMARY_FG=black

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"
POO="💩 " # only OS X

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=$(whoami)

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    prompt_segment 234 245 " %(!.%{%F{yellow}%}.)$user@%m "
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=178
      ref="${ref} $PLUSMINUS"
    else
      color=118
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -Pn " $ref"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 31 $fg_bold[$PRIMARY_FG] ' %c '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

prompt_agnoster_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) '
}

prompt_agnoster_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"

#PROMPT='%{$fg_bold[white]%}%c%{$reset_color%}:%(?.%{$FG[040]%}.%{$FG[196]%}%?)${SEP}%{$reset_color%}'

#RPROMPT='%{$fg[white]%}%{$FG[239]%}[%{$FG[033]%}%D{%H:%M:%S}%{$FG[239]%}]$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}'

#ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[123]%}[%{$reset_color%}%{$fg[gray]%}\ue0a0%{$fg[gray]%}:%{$fg[white]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$FG[123]%}]%{$fg[white]%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[124]%} ✗%{$reset_color%}" # 💩 
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[082]%} ✓%{$reset_color%}"
 
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[226]%} ✭ " # ⓣ

#ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%} ✚ " # ⓐ ⑃
#ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✹ "  # ⓜ ⑁
#ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[124]%} ✖ " # ⓧ ⑂
#ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[021]%} ➜ " # ⓡ ⑄
#ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[164]%} ♒ " # ⓤ ⑊
#ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
#ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
#ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"
