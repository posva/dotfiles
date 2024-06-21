
-- Load external Lua settings file
-- vim.cmd('luafile ' .. vim.fn.stdpath('config') .. '/lua/settings.lua')

-- Manage editor size
local function manageEditorSize(count, to)
    count = count or 1
    for i = 1, count do
        if to == 'increase' then
            vim.fn.VSCodeNotify('workbench.action.increaseViewSize')
        else
            vim.fn.VSCodeNotify('workbench.action.decreaseViewSize')
        end
    end
end

-- VSCode commentary function
local function vscodeCommentary(...)
    local args = {...}
    if #args == 0 then
        vim.o.operatorfunc = 'v:lua.vscodeCommentary'
        return 'g@'
    else
        local line1, line2 = args[1], args[2]
        vim.fn.VSCodeCallRange('editor.action.commentLine', line1, line2, 0)
    end
end

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
local function openWhichKeyInVisualMode()
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

-- Commentary
keymap('x', '<C-_>', 'v:lua.vscodeCommentary()', { expr = true, silent = true })
keymap('n', '<C-_>', 'v:lua.vscodeCommentary() .. "_"', { expr = true, silent = true })
keymap('n', '<C-w>_', ":call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>", opts)
keymap('n', '<Space>', ":call VSCodeNotify('whichkey.show')<CR>", opts)
keymap('x', '<Space>', ":lua openWhichKeyInVisualMode()<CR>", opts)
keymap('x', '<C-P>', ":lua openVSCodeCommandsInVisualMode()<CR>", opts)

-- Commentary mappings
keymap('x', 'gc', '<Plug>VSCodeCommentary', {})
keymap('n', 'gc', '<Plug>VSCodeCommentary', {})
keymap('o', 'gc', '<Plug>VSCodeCommentary', {})
keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})

-- Tab navigation
keymap('n', '<Tab>', ':Tabnext<CR>', opts)
keymap('n', '<S-Tab>', ':Tabprev<CR>', opts)

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
})

