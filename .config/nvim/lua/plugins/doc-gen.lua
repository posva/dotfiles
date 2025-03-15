return {
  "kkoomen/vim-doge",
  -- ft = { "javascript", "typescript" },
  lazy = false,
  event = "VeryLazy",
  keys = {
    {
      "<leader>D",
      "<Plug>(doge-generate)",
      { desc = "doge generate" },
    },
  },
}
