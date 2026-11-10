Use the global `rex-layout` shell function:

```sh
rex-layout          # Show help
rex-layout save     # Replace layout.json with the current layout
rex-layout restore  # Create missing sessions from layout.json
```

The function is defined in `~/dotfiles/aliases`. Open a new shell or run
`source ~/dotfiles/aliases` to load it. The scripts use Bash, `jq`, and `rex`.
Set `REX_BIN` to use another Rex executable.

You can also call the script from another shell or program:

```sh
bash ~/dotfiles/.config/rex/rex-layout.sh save
```

There is one saved layout: `layout.json`, next to the scripts. Saving reads all
sessions before it replaces the file. If a read fails or the layout is
unsupported, the previous file stays in place. The replacement is atomic.

Each tab must have one tiled layer of terminal panes. Nested horizontal and
vertical splits are supported. The snapshot stores session and tab labels,
tab order, pane directories, program names, focus, and split ratios.

Restore skips sessions whose names already exist. It checks all directories
before it creates sessions. If creation fails partway through, inspect that
session before you retry. The initial snapshot format is also supported.

Restore starts shells in the saved directories. It does not restore running
programs, agent conversations, terminal output, shell history, pane zoom state,
or native app window placement. Select a restored session in Rex to display it.

Run the behavior tests with `bash ~/.config/rex/layout.test.sh`.
