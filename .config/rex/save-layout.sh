#!/bin/bash
set -euo pipefail

directory=$(cd -- "$(dirname -- "$0")" && pwd)
rex=${REX_BIN:-rex}
command -v jq >/dev/null
temporary=$(mktemp -d "$directory/.layout.XXXXXX")
trap 'rm -rf -- "$temporary"' EXIT

"$rex" --autostart=false ls --json > "$temporary/sessions.json"
jq -er '.sessions | if length == 0 then error("No Rex sessions to save") else .[].session_id end' \
  "$temporary/sessions.json" > "$temporary/ids"
while IFS= read -r session; do
  "$rex" --autostart=false session inspect "$session" --json >> "$temporary/views.json"
done < "$temporary/ids"

jq -rs '.[] | .session_id as $session | .windows[].layers[].blocks[] | [$session, .block_id] | @tsv' \
  "$temporary/views.json" > "$temporary/blocks"
while IFS=$'\t' read -r session block; do
  "$rex" --autostart=false block call -s "$session" -b "$block" process > "$temporary/process.json"
  jq --arg id "$block" '{key: $id, value: .}' "$temporary/process.json" >> "$temporary/processes.json"
done < "$temporary/blocks"

jq -s --slurpfile processes "$temporary/processes.json" -f "$directory/save-layout.jq" \
  "$temporary/views.json" > "$temporary/layout.json"
mv -- "$temporary/layout.json" "$directory/layout.json"
printf 'Saved layout to %s/layout.json\n' "$directory"
