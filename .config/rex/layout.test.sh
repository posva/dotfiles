#!/bin/bash
set -euo pipefail
root=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'trash "$tmp" 2>/dev/null || :' EXIT
cp "$root/"*.sh "$tmp/"
cp "$root/"*.jq "$tmp/"
mkdir -p "$tmp/first pane" "$tmp/second" "$tmp/third"
export REX_BIN="$root/test/rex" REX_TEST_STATE="$tmp/state.json"
jq -n --arg cwd "$tmp" '{next: 10, sessions: [{session_id: "s", label: "work space", active_window_id: "w2", windows: [
 {window_id: "w1", label: "single pane", focused_block_id: "b1", layers: [{kind: "tiled", layout: {block_id: "b1"}, blocks: [{block_id: "b1", creator_name: "com.superlogical.terminal", cwd: ($cwd + "/first pane")}]}]},
 {window_id: "w2", label: "nested panes", focused_block_id: "b3", layers: [{kind: "tiled", layout: {split: {direction: "horizontal", ratio: 0.4, before: {block_id: "b2"}, after: {split: {direction: "vertical", ratio: 0.25, before: {block_id: "b3"}, after: {block_id: "b4"}}}}}, blocks: [
 {block_id: "b4", creator_name: "com.superlogical.terminal", cwd: ($cwd + "/third")},
 {block_id: "b2", creator_name: "com.superlogical.terminal", cwd: ($cwd + "/first pane")},
 {block_id: "b3", creator_name: "com.superlogical.terminal", cwd: ($cwd + "/second")}
 ]}]}]}]}' > "$REX_TEST_STATE"
bash "$tmp/save-layout.sh"
jq -e --arg cwd "$tmp" '.[0] | .label == "work space" and .activeWindow == 1 and (.windows[0] | .focusedPane == 0 and .panes[0].cwd == ($cwd + "/first pane")) and (.windows[1] | .focusedPane == 1 and [.panes[].cwd] == [($cwd + "/first pane"), ($cwd + "/second"), ($cwd + "/third")] and .tree.direction == "right" and .tree.ratio == 60 and .tree.after.direction == "below" and .tree.after.ratio == 75)' "$tmp/layout.json" >/dev/null
cp "$tmp/layout.json" "$tmp/expected.json"
if REX_TEST_FAIL=1 bash "$tmp/save-layout.sh" >/dev/null 2>&1; then
  echo 'Failed terminal read must fail saving' >&2; exit 1
fi
cmp "$tmp/layout.json" "$tmp/expected.json"
printf '{"next":0,"sessions":[]}\n' > "$REX_TEST_STATE"
bash "$tmp/restore-layout.sh"
bash "$tmp/save-layout.sh"
# Compare the observable layout after restoring, without generated Rex IDs.
jq -S . "$tmp/layout.json" > "$tmp/actual.sorted"
jq -S . "$tmp/expected.json" > "$tmp/expected.sorted"
cmp "$tmp/actual.sorted" "$tmp/expected.sorted"
bash "$tmp/restore-layout.sh"
jq -e '.sessions | length == 1' "$REX_TEST_STATE" >/dev/null
# Old snapshots store a flat two-pane split instead of a tree.
jq '.[0].windows[1] |= (.panes = .panes[0:2] | .split = {direction: "right", ratio: 60} | del(.tree))' "$tmp/expected.json" > "$tmp/layout.json"
cp "$tmp/layout.json" "$tmp/legacy.json"
printf '{"next":0,"sessions":[]}\n' > "$REX_TEST_STATE"
bash "$tmp/restore-layout.sh"
bash "$tmp/save-layout.sh"
jq -S . "$tmp/layout.json" > "$tmp/actual.sorted"
jq -S . "$tmp/legacy.json" > "$tmp/expected.sorted"
cmp "$tmp/actual.sorted" "$tmp/expected.sorted"
bash "$tmp/rex-layout.sh" | rg -q 'save'
if bash "$tmp/rex-layout.sh" invalid >/dev/null 2>&1; then
  echo 'Unknown command must fail' >&2; exit 1
fi
printf 'Layout save, restore, failure, repeat restore, and help tests passed.\n'
