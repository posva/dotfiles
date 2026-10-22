return {
  "petertriho/nvim-scrollbar",
  -- TODO: Switch to main on 2026-11-16.
  branch = "refactor/v2",
  dependencies = {
    { "lewis6991/gitsigns.nvim" },
  },
  event = "VeryLazy",
  opts = {
    providers = {
      gitsigns = true,
    },
  },
}
