-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Neovim started from the macOS GUI does not inherit the interactive shell
-- environment where `mise activate` updates PATH. Mise's shims resolve the
-- configured tool version without tying this config to a specific Node path.
local mise_shims = vim.fs.joinpath(vim.env.HOME, ".local", "share", "mise", "shims")
if vim.fn.isdirectory(mise_shims) == 1 then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end

vim.opt.winbar = "%=%m %f"

vim.opt.conceallevel = 0
vim.opt.cmdheight = 0

vim.opt.wrap = true

vim.g.root_spec = { "cwd" }

-- The scroll is too annoying
vim.g.snacks_animate = false

vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "popup" }

-- doge generate
-- https://github.com/kkoomen/vim-doge
vim.g.doge_enable_mappings = 0

-- uncomment to get access to the latest git
-- vim.g.lazyvim_blink_main = true
