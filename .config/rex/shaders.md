# Cursor shaders

Rex uses the built-in Comet cursor shader. The settings are saved in
`~/dotfiles/osx/defaults.sh`, with the other Rex appearance settings.
To apply only these settings:

```sh
defaults write com.superlogical.rex rex.developer-mode-enabled -bool true
defaults write com.superlogical.rex Workspace.cursorShader -string comet
defaults write com.superlogical.rex Workspace.cursorShadersEnabled -bool true
```

Quit and reopen the Rex app if it does not show the change.
In the UI, use Settings > Developer > Experimental > Cursor shaders.

The [Rex settings reference](https://www.superlogical.com/rex/docs/reference/mac-settings#setting-experimental-cursor-shaders)
lists built-in effects such as Warp, Comet, and Blaze. As of 2026-11-10,
the public docs do not describe a custom shader file setting or a Lua API
to load one. The installed app has built-in shader choices and a Metal
cursor shader renderer.

Ghostty uses `~/.config/ghostty/shaders/cursor-matrix.glsl`: a green cursor
trail with a 0.5-second duration. That file is already tracked in Git.
It uses GLSL `mainImage` and Ghostty cursor uniforms, including
`iCurrentCursor`, `iPreviousCursor`, and `iTimeCursorChange`.
There is no documented way to load this file in Rex. Keep it in the Ghostty
config until Rex provides a custom shader file API.
