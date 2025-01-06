return {
  "kkoomen/vim-doge",
  -- ft = { "javascript", "typescript" },
  config = function()
    vim.g.doge_enable_mappings = 0
    vim.keymap.set("n", "gcd", ":DogeGenerate<CR>", { desc = "Generate docs", noremap = true, silent = true })
  end,
}
