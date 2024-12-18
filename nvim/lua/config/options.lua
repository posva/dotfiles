-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %f"

vim.opt.conceallevel = 0
vim.opt.cmdheight = 0

vim.opt.wrap = true

vim.g.root_spec = { "cwd" }

-- The scroll is too annoying
vim.g.snacks_animate = false
