return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.dashboard.preset.header = require("config.logos").random()
  end,
}
