#!/bin/bash
# Claude Code Status Line: path | branch | status | model | context% | cost

input=$(cat)

# Extract all values in single jq call (IFS=tab because model name has spaces)
IFS=$'\t' read -r cwd model_name cost context_pct context_size <<< "$(echo "$input" | jq -r '[
  .workspace.current_dir,
  .model.display_name,
  (.cost.total_cost_usd // 0),
  (.context_window.used_percentage // 0),
  (.context_window.context_window_size // 0)
] | @tsv')"

output=""

# Abbreviated path (dimmed): ~/foo/bar/baz -> ~/f/b/baz
cd "$cwd" 2>/dev/null || cd "$HOME"
path="${cwd/#$HOME/~}"
abbrev=$(echo "$path" | awk -F/ '{
  for(i=1;i<NF;i++) {
    c = substr($i,1,1)
    if (c == "~") printf "~/"
    else if (length($i)>0) printf "%s/", c
  }
  print $NF
}')
output=$(printf "\033[2m%s\033[0m" "$abbrev")

# Git branch + status
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  [ -n "$branch" ] && output="${output} | $(printf "\033[0;32m%s\033[0m" "$branch")"

  status=$(git --no-optional-locks status --porcelain 2>/dev/null)
  if [ -n "$status" ]; then
    staged=$(echo "$status" | grep -c '^[AMDRC]')
    modified=$(echo "$status" | grep -c '^ M')
    added=$(echo "$status" | grep -c '^??')

    git_status=""
    [ "$staged" -gt 0 ] && git_status+="S:${staged} "
    [ "$modified" -gt 0 ] && git_status+="M:${modified} "
    [ "$added" -gt 0 ] && git_status+="?:${added}"
    [ -n "$git_status" ] && output="${output} $(printf "\033[2;33m%s\033[0m" "${git_status% }")"
  fi
fi

# Model name
[ -n "$model_name" ] && [ "$model_name" != "null" ] && output="${output} | ${model_name}"

# Context percentage with color coding
if [ "$context_size" -gt 0 ] 2>/dev/null; then
  pct=${context_pct%.*}  # truncate decimal
  if [ "$pct" -ge 80 ]; then
    color="\033[0;31m"  # red
  elif [ "$pct" -ge 50 ]; then
    color="\033[0;33m"  # yellow
  else
    color="\033[0;32m"  # green
  fi
  output="${output} | $(printf "${color}%d%%\033[0m" "$pct")"
fi

# Cost
if [ -n "$cost" ] && [ "$cost" != "0" ] 2>/dev/null; then
  cost_display=$(printf "%.4f" "$cost")
  output="${output} | \$${cost_display}"
fi

echo "$output"
