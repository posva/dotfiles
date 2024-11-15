return {
  -- Automatically installs tailwindcss language server.
  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },

  -- Colorizes classes
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },

  -- Color preview in autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- adds icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
