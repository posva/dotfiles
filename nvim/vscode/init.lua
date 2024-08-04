-- Load external Lua settings file
-- vim.cmd('luafile ' .. vim.fn.stdpath('config') .. '/lua/settings.lua')

-- Open VSCode commands in visual mode
local function openVSCodeCommandsInVisualMode()
  vim.cmd('normal! gv')
  local visualmode = vim.fn.visualmode()
  if visualmode == 'V' then
    local startLine = vim.fn.line('v')
    local endLine = vim.fn.line('.')
    vim.fn.VSCodeNotifyRange('workbench.action.showCommands', startLine, endLine, 1)
  else
    local startPos = vim.fn.getpos('v')
    local endPos = vim.fn.getpos('.')
    vim.fn.VSCodeNotifyRangePos('workbench.action.showCommands', startPos[2], endPos[2], startPos[3], endPos[3], 1)
  end
end

-- Open whichkey in visual mode
function openWhichKeyInVisualMode()
  vim.cmd('normal! gv')
  local visualmode = vim.fn.visualmode()
  if visualmode == 'V' then
    local startLine = vim.fn.line('v')
    local endLine = vim.fn.line('.')
    vim.fn.VSCodeNotifyRange('whichkey.show', startLine, endLine, 1)
  else
    local startPos = vim.fn.getpos('v')
    local endPos = vim.fn.getpos('.')
    vim.fn.VSCodeNotifyRangePos('whichkey.show', startPos[2], endPos[2], startPos[3], endPos[3], 1)
  end
end

-- Key mappings
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Better Navigation
keymap('n', '<C-j>', ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opts)
keymap('x', '<C-j>', ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opts)
keymap('n', '<C-k>', ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opts)
keymap('x', '<C-k>', ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opts)
keymap('n', '<C-h>', ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opts)
keymap('x', '<C-h>', ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opts)
keymap('n', '<C-l>', ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opts)
keymap('x', '<C-l>', ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opts)
keymap('n', 'gr', ":call VSCodeNotify('editor.action.goToReferences')<CR>", opts)

keymap('n', '<Space>', ":call VSCodeNotify('whichkey.show')<CR>", opts)
keymap('x', '<Space>', ":lua openWhichKeyInVisualMode()<CR>", opts)
-- keymap('x', '<C-P>', ":lua openVSCodeCommandsInVisualMode()<CR>", opts)

-- Commentary mappings
keymap('x', 'gc', '<Plug>VSCodeCommentary', {})
keymap('n', 'gc', '<Plug>VSCodeCommentary', {})
keymap('o', 'gc', '<Plug>VSCodeCommentary', {})
keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})

-- Open links
keymap('n', 'gl', ':call VSCodeNotify("editor.action.openLink")<CR>', opts)

-- Tab navigation
keymap('n', '<Tab>', ':Tabnext<CR>', opts)
keymap('n', '<S-Tab>', ':Tabprev<CR>', opts)

-- Multi cursor
-- remapped to cmd+d in vscode keybindings
vim.keymap.set('n', '<C-d>', 'mciw*<Cmd>nohl<CR>', { remap = true })

-- Clipboard setting
-- vim.o.clipboard = 'unnamedplus'

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'tpope/vim-repeat', },
  { 'tpope/vim-surround', },
  "easymotion/vim-easymotion",
  {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = not not vim.g.vscode,
    opts = {},
  }
})
