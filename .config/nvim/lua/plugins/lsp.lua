return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- TODO: disable a keymap
      -- keys[#keys + 1] = { "K", false }

      -- change a keymap
      keys[#keys + 1] = {
        "gh",
        function()
          return vim.lsp.buf.hover()
        end,
        desc = "Hover",
      }
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    opts = {
      automatic_enable = {
        -- FIXME: doesn't work
        exclude = {
          "volar",
        },
      },
      ensure_installed = {
        "ast_grep",
        "tailwindcss",
        "cssls",
        "html",
        "lua_ls",
        "vtsls",
        -- "vue_ls", -- not a valid entry
        -- TODO: should be vue_ls maybe in the future?
        -- "volar",
      },
    },
  },
}
