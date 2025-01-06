return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    { "kevinhwang91/nvim-hlslens" },
    { "lewis6991/gitsigns.nvim" },
  },
  event = "VeryLazy",
  opts = {
    handlers = {
      cursor = true,
      diagnostic = true,
      gitsigns = true,
      handle = true,
      search = true,
    },
  },
}
