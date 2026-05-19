return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].keys = opts.servers["*"].keys or {}
      table.insert(opts.servers["*"].keys, {
        "gh",
        function() return vim.lsp.buf.hover() end,
        desc = "Hover",
      })

      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.keys = opts.servers.vtsls.keys or {}
      table.insert(opts.servers.vtsls.keys, {
        "<leader>cu",
        LazyVim.lsp.action["source.removeUnused.ts"],
        desc = "Remove unused",
      })
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
