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

-- Workaround for nvim 0.12.2 bug: vim.lsp.document_color asserts on a stale
-- client_id after LspRestart (document_color.lua:225, fires from on_lines
-- after apply_text_edits). Strip colorProvider from servers that don't return
-- meaningful colors anyway; keep it on tailwindcss/cssls.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if client.name == "vtsls" or client.name == "vue_ls" then
      client.server_capabilities.colorProvider = nil
    end
  end,
})
