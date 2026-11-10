def leaves:
  if .block_id and (.split == null) then .block_id
  elif .split and (.block_id == null) then .split | (.before, .after) | leaves
  else error("Invalid split tree") end;

def tree($ids):
  if .block_id then {pane: (.block_id as $id | $ids | index($id))}
  else .split |
    if (.direction != "horizontal" and .direction != "vertical") or
      (.ratio | type) != "number" or .ratio <= 0 or .ratio >= 1
    then error("Invalid split direction or ratio") else
      {direction: (if .direction == "horizontal" then "right" else "below" end),
       ratio: (((1 - .ratio) * 100 * 100000000 | round) / 100000000),
       before: (.before | tree($ids)), after: (.after | tree($ids))}
    end
  end;

($processes | from_entries) as $processes |
map(
  . as $session |
  (.windows | map(.window_id) | index($session.active_window_id)) as $active |
  if (.windows | length) == 0 or $active == null then error("Missing active window") else
    {label, activeWindow: $active, windows: [.windows[] |
      . as $window |
      if (.layers | length) != 1 or .layers[0].kind != "tiled"
      then error("Unsupported layers in " + .label) else
        .layers[0] as $layer |
        [$layer.layout | leaves] as $ids |
        ($ids | index($window.focused_block_id)) as $focus |
        if $focus == null or ($ids | length) == 0 or
          ($ids | sort) != ($layer.blocks | map(.block_id) | sort) or
          ($ids | unique | length) != ($ids | length) or
          any($layer.blocks[]; .creator_name != "com.superlogical.terminal")
        then error("Unsupported panes in " + $window.label) else
          ($layer.layout | tree($ids)) as $tree |
          {label: $window.label, focusedPane: $focus,
           panes: [$ids[] | $processes[.] |
             (.foreground.cwd // ([.ancestors[]? | .cwd // empty][0]) // .child.cwd) as $cwd |
             if ($cwd | type) != "string" or ($cwd | startswith("/") | not)
             then error("Cannot read pane working directory") else
               {cwd: $cwd, program: (.foreground.script // .foreground.argv0 // .foreground.name // .child.name // "")}
             end],
           split: (if ($ids | length) == 2 then $tree | {direction, ratio} else null end)} +
          (if ($ids | length) > 2 then {tree: $tree} else {} end)
        end
      end]}
  end
)
