return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "svelte" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {},
      },
    },
  },
}
