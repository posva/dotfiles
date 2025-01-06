return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- disable a keymap
    keys[#keys + 1] = { "K", false }
    -- change a keymap
    keys[#keys + 1] = {
      "gh",
      function()
        return vim.lsp.buf.hover()
      end,
      desc = "Hover",
    }
  end,
}
