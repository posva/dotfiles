return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      -- Adapters
      -- "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      -- table.insert(opts.adapters, require("neotest-jest"))
      -- table.insert(opts.adapters, require("neotest-vitest"))
      opts.adapters["neotest-vitest"] = {}
    end,
  },
}
