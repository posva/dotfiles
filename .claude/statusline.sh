#!/bin/bash
# Claude Code Status Line: path | branch | status | model | tokens | cost

input=$(cat)

get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_transcript_path() { echo "$input" | jq -r '.transcript_path'; }
get_total_cost() { echo "$input" | jq -r '.cost.total_cost_usd // empty'; }

output=""

# Abbreviated path (dimmed)
cwd=$(get_current_dir)
cd "$cwd" 2>/dev/null || cd "$HOME"

path="$cwd"
path="${path/#$HOME/~}"
IFS='/' read -ra parts <<<"$path"
result=""
len=${#parts[@]}

for ((i = 0; i < len; i++)); do
  [ -z "${parts[i]}" ] && continue

  if [ $i -eq $((len - 1)) ]; then
    [ -n "$result" ] && result="${result}/${parts[i]}" || result="${parts[i]}"
  else
    first_char="${parts[i]:0:1}"
    [ -n "$result" ] && result="${result}/${first_char}" || result="${first_char}"
  fi
done

output=$(printf "\033[2m%s\033[0m" "$result")

# Git branch
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch 2>/dev/null | grep '^*' | sed 's/\* //')
  output="${output} | $(printf "\033[0;32m%s\033[0m" "$branch")"

  # Git status counts (staged, modified, added)
  status=$(git --no-optional-locks status --porcelain 2>/dev/null)

  if [ -n "$status" ]; then
    staged=$(echo "$status" | grep -c '^[AMDRC]')
    modified=$(echo "$status" | grep -c '^ M')
    added=$(echo "$status" | grep -c '^??')

    [ "$staged" -gt 0 ] && output="${output} | S: $(printf "\033[2;33m%s\033[0m" "$staged")"
    [ "$modified" -gt 0 ] && output="${output} | M: $(printf "\033[2;33m%s\033[0m" "$modified")"
    [ "$added" -gt 0 ] && output="${output} | A: $(printf "\033[2;33m%s\033[0m" "$added")"
  fi
fi

# Model name
model_name=$(get_model_name)
[ -n "$model_name" ] && [ "$model_name" != "null" ] && output="${output} | ${model_name}"

# Token usage
transcript_path=$(get_transcript_path)

if [ -f "$transcript_path" ]; then
  token_info=$(jq -r '[.messages[] | select(.type == "system_warning" and (.content | tostring | contains("Token usage:"))) | .content] | last' "$transcript_path" 2>/dev/null)

  if [ -n "$token_info" ] && [ "$token_info" != "null" ]; then
    if [[ "$token_info" =~ Token\ usage:\ ([0-9]+)/([0-9]+) ]]; then
      used="${BASH_REMATCH[1]}"
      total="${BASH_REMATCH[2]}"

      [ "$used" -ge 1000 ] && used_display="$((used / 1000))k" || used_display="$used"
      [ "$total" -ge 1000 ] && total_display="$((total / 1000))k" || total_display="$total"

      output="${output} | Tokens: ${used_display}/${total_display}"
    fi
  fi
fi

# Cost
cost=$(get_total_cost)
if [ -n "$cost" ] && [ "$cost" != "null" ] && [ "$cost" != "0" ]; then
  cost_display=$(printf "%.4f" "$cost")
  output="${output} | \$${cost_display}"
fi

echo "$output"
