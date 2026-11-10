#!/bin/bash
set -euo pipefail

if [ "$#" -ne 0 ]; then
  echo 'Usage: restore-layout.sh' >&2
  exit 2
fi

rex=${REX_BIN:-rex}
config_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

plan=$(jq -r '
  def index_ok($n): type == "number" and floor == . and . >= 0 and . < $n;
  def valid_tree:
    if has("pane") then (.pane | type == "number" and floor == . and . >= 0)
    else
      (.direction == "right" or .direction == "below" or .direction == "above" or .direction == "left")
      and (.ratio | type == "number" and . > 0 and . < 100)
      and (.before | valid_tree) and (.after | valid_tree)
    end;
  def leaves: if has("pane") then .pane else (.before | leaves), (.after | leaves) end;
  def first: if has("pane") then .pane else .before | first end;
  def call($name; $args): $name + " " + ($args | @sh);
  def splits($panes):
    if has("pane") then empty else
      call("restore_split"; [(.before | first), (.after | first), .direction, .ratio, $panes[(.after | first)].cwd]),
      (.before | splits($panes)), (.after | splits($panes))
    end;
  if type != "array" or length == 0 then error("No sessions in saved layout") else . end
  | map(
      if (.label | type != "string") or (.windows | type != "array" or length == 0)
        then error("Invalid saved session") else . end
      | . as $session
      | if (.activeWindow | index_ok($session.windows | length)) then . else error("Invalid active tab") end
      | .windows |= map(
          if (.label | type != "string") or (.panes | type != "array" or length == 0)
            then error("Invalid saved tab") else . end
          | . as $window
          | if all(.panes[]; (.cwd | type == "string" and startswith("/")))
              and (.focusedPane | index_ok($window.panes | length)) then . else error("Invalid saved pane") end
          | .tree //= (if .split then
              {direction: .split.direction, ratio: .split.ratio, before: {pane: 0}, after: {pane: 1}}
              else {pane: 0} end)
          | if (.tree | valid_tree) and ([.tree | leaves] == [range(0; .panes | length)])
              then . else error("Invalid saved split tree") end
        )
    )
  | (.[].windows[].panes[] | call("check_directory"; [.cwd])),
    (.[] | .activeWindow as $active |
      call("restore_session"; [.label]),
      (.windows | to_entries[] | .key as $index | .value |
        .panes as $panes |
        call("restore_window"; [$index, .label, .panes[0].cwd]),
        (.tree | splits($panes)),
        call("restore_pane_focus"; [.focusedPane])
      ),
      call("restore_window_focus"; [$active])
    )
' "$config_dir/layout.json")

check_directory() {
  if [ ! -d "$1" ]; then
    printf 'Missing directory: %s\n' "$1" >&2
    exit 1
  fi
}

restore_session() {
  session_label=$1
  session_id=
  window_ids=()
  skip=$(jq -r --arg label "$1" 'any(.sessions[]; .label == $label)' <<< "$existing")
  if [ "$skip" = true ]; then
    printf 'Skip existing session: %s\n' "$1"
  else
    printf 'Restore session: %s\n' "$1"
  fi
}

restore_window() {
  [ "$skip" = false ] || return 0
  local result created
  if [ "$1" -eq 0 ]; then
    result=$("$rex" new "$session_label" --window "$2" -c "$3" --json)
    session_id=$(jq -er '.session_id' <<< "$result")
    created=$(jq -ec '.initial_windows[0]' <<< "$result")
  else
    created=$("$rex" window new -s "$session_id" "$2" -c "$3" --json)
  fi
  window_ids[$1]=$(jq -er '.window_id' <<< "$created")
  pane_ids=("$(jq -er '.block_ids[0]' <<< "$created")")
}

restore_split() {
  [ "$skip" = false ] || return 0
  local result
  result=$("$rex" split -s "$session_id" -b "${pane_ids[$1]}" --split "$3" --ratio "$4" -c "$5" --json)
  pane_ids[$2]=$(jq -er '.block_ids[0]' <<< "$result")
}

restore_pane_focus() {
  [ "$skip" = false ] || return 0
  "$rex" focus -s "$session_id" "${pane_ids[$1]}" >/dev/null
}

restore_window_focus() {
  [ "$skip" = false ] || return 0
  "$rex" focus -s "$session_id" "${window_ids[$1]}" >/dev/null
}

# All values in this plan are quoted by jq with @sh.
existing=$("$rex" --autostart=false ls --json)
eval "$plan"
