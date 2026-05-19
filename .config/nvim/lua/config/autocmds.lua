-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Built-in ftplugins (css, sass, scss, stylus, astro, toml, …) do `setlocal iskeyword+=-`,
-- making `w`/`b`/`e`/`*` treat `very-long-class` as one word. Strip it back out.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "scss", "sass", "less", "stylus", "astro", "vue", "html", "toml" },
  callback = function()
    vim.opt_local.iskeyword:remove("-")
  end,
})
