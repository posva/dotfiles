return {
  {
    "vimpostor/vim-lumen",
    event = "LazyFile",
    priority = 10010,
    init = function()
      vim.cmd([[
				au User LumenLight echom 'tokyonight-day'
				au User LumenDark echom 'tokyonight-moon'
			]])
    end,
  },
}
