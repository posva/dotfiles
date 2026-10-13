-- Appearance and terminal settings: ~/dotfiles/osx/defaults.sh.
-- UI shortcuts take priority over these bindings.
rex.bind("cmd+[Digit3]", "client.tab.previous")
rex.bind("cmd+[Digit4]", "client.tab.next")

rex.unbind("shift+cmd+[BracketLeft]", "client.tab.previous")
rex.unbind("ctrl+shift+tab", "client.tab.previous")
rex.unbind("shift+cmd+[BracketRight]", "client.tab.next")
rex.unbind("ctrl+tab", "client.tab.next")

local function send_text(key, text)
  rex.bind(key, function()
    local result, err = rex.block.call("com.superlogical.terminal", "write", { data = text })
    if err then error(err, 0) end
    return result ~= nil
  end)
end

send_text("ctrl+enter", "gst\n")
send_text("shift+enter", "\n")
-- Send plain bytes to avoid extended key sequences in zsh vi mode.
send_text("shift+space", " ")
send_text("shift+backspace", "\127")
send_text("ctrl+d", "\004")

-- Rex has no documented custom-shader API for Ghostty GLSL shaders.
-- Ghostty shader: ~/.config/ghostty/shaders/cursor-matrix.glsl
-- CJK font mapping remains in Ghostty; no Rex setting was found for it.
-- U+4E00-9FFF, U+3400-4DBF, U+3000-303F, U+FF00-FFEF: LXGW WenKai Mono.
