return {
  "jiaoshijie/undotree",
  -- event = "BufRead",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = {
    -- load the plugin only when using it's keybinding:
    { "<leader>U", "<cmd>lua require('undotree').setup()<cr><cmd>lua require('undotree').toggle()<cr>" },
  },
}
