return {
  "Wansmer/treesj",
  keys = { "<space>jt" },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
}
