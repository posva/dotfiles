source "${${(%):-%x}:A:h}/pnpm.zsh"

# colored log helper: _wt_log <color> <message>
# colors: info=blue ok=green warn=yellow err=red
function _wt_log() {
  local -A colors=(info blue ok green warn yellow err red)
  print -P "%F{${colors[$1]}}==>%f $2"
}

# gw [branch]: cd into the branch's worktree, creating it if needed
# worktrees live in <repo>/.posva/worktrees (git-excluded)
# no arg: pick (or type a new name) with fzf
function git_create_worktree() {
  local branch=$1 out dir gitdir root target setup_result
  local -a lines

  git rev-parse --git-dir >/dev/null 2>&1 || { _wt_log err "not a git repo"; return 1 }

  if [[ -z "$branch" ]]; then
    out=$(git branch --all --format='%(refname:short)' | sed 's#^origin/##' | sort -u \
      | fzf --prompt='worktree> ' --height=~50% --print-query)
    (( $? == 130 )) && return 1
    # last line: the selection, or the typed query when nothing matched
    lines=(${(f)out})
    (( ${#lines} )) || return 1
    git_create_worktree "${lines[-1]}"
    return
  fi

  dir=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
    $1 == "worktree" { d = substr($0, 10) }
    $1 == "branch" && $2 == b { print d; exit }')
  if [[ -n "$dir" ]]; then
    _wt_log info "worktree exists, switching: $dir"
    cd "$dir"
    return
  fi

  gitdir=$(git rev-parse --path-format=absolute --git-common-dir)
  root=${gitdir%/.git}
  target="$root/.posva/worktrees/${branch//\//-}"

  # ignore worktrees without touching the repo's .gitignore
  mkdir -p "$gitdir/info"
  grep -qxF '.posva/' "$gitdir/info/exclude" 2>/dev/null \
    || echo '.posva/' >>"$gitdir/info/exclude"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    _wt_log info "creating worktree for existing branch '$branch' at $target"
    git worktree add "$target" "$branch"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    _wt_log info "creating worktree for '$branch' tracking origin/$branch at $target"
    git worktree add -b "$branch" "$target" "origin/$branch"
  else
    _wt_log info "creating worktree with new branch '$branch' at $target"
    git worktree add -b "$branch" "$target"
  fi || return $?

  cd "$target" || return $?
  posva_worktree_setup || {
    setup_result=$?
    _wt_log err "setup failed; worktree kept at $target. Run posva_worktree_setup to retry."
    return "$setup_result"
  }
  _wt_log ok "ready: $target"
}
alias gw=git_create_worktree

# gwd [branch]: delete the branch's worktree
# no arg: inside a worktree deletes it, otherwise pick with fzf
# prompts if the worktree has changes (only 'y' confirms)
function git_delete_worktree() {
  local branch=$1 dir main force reply

  git rev-parse --git-dir >/dev/null 2>&1 || { _wt_log err "not a git repo"; return 1 }

  main=$(git rev-parse --path-format=absolute --git-common-dir)
  main=${main%/.git}

  if [[ -z "$branch" ]]; then
    if [[ "$(git rev-parse --show-toplevel)" != "$main" ]]; then
      dir=$(git rev-parse --show-toplevel)
    else
      branch=$(git worktree list --porcelain | awk '
        $1 == "worktree" { n++ }
        $1 == "branch" && n > 1 { sub("refs/heads/", "", $2); print $2 }' \
        | fzf --prompt='delete worktree> ' --height=~50%)
      [[ -z "$branch" ]] && return 1
    fi
  fi

  if [[ -z "$dir" ]]; then
    dir=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
      $1 == "worktree" { d = substr($0, 10) }
      $1 == "branch" && $2 == b { print d; exit }')
    [[ -z "$dir" ]] && { _wt_log err "no worktree for '$branch'"; return 1 }
  fi
  [[ "$dir" == "$main" ]] && { _wt_log err "refusing to remove main worktree"; return 1 }

  if [[ -n "$(git -C "$dir" status --porcelain)" ]]; then
    read -r "reply?worktree '$dir' has changes, delete anyway? [y/N] "
    [[ "$reply" == y ]] || return 1
    force=--force
  fi

  [[ "${PWD:A}" == "$dir" || "${PWD:A}" == "$dir"/* ]] && cd "$main"
  _wt_log info "removing worktree $dir"
  git worktree remove ${force:+--force} "$dir" && _wt_log ok "removed $dir"
}
alias gwd=git_delete_worktree
