return {
  "Wansmer/treesj",
  keys = { "<space>jt" },
  -- disable if running in vscode
  vscode = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
}
