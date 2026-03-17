return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "gh", function() return vim.lsp.buf.hover() end, desc = "Hover" },
          },
        },
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    opts = {
      automatic_enable = true,
      ensure_installed = {
        "ast_grep",
        "tailwindcss",
        "cssls",
        "html",
        "lua_ls",
        "vtsls",
        "vue_ls",
      },
    },
  },
}
