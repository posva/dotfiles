return {
  {
    "vimpostor/vim-lumen",
    event = "LazyFile",
    priority = 10010,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LumenLight",
        callback = function()
          -- Add your callback code here for LumenLight
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "LumenDark",
        callback = function()
          -- Add your callback code here for LumenDark
        end,
      })
    end,
  },
}
