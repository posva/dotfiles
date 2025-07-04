return {
  -- recommended = function()
  --   return LazyVim.extras.wants({
  --     ft = "vue",
  --     root = { "vue.config.js" },
  --   })
  -- end,
  --
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },

  -- Add LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {},
        -- vue_ls = {}, not a valid entry
      },
    },
  },
}
