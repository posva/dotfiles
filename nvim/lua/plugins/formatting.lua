return {
  "conform.nvim",
  opts = function(_, opts)
    if LazyVim.has_extra("formatting.prettier") then
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local web_formatters = { "eslint_d", "prettier" }
      opts.formatters_by_ft.javascript = web_formatters
      opts.formatters_by_ft.typescript = web_formatters
      opts.formatters_by_ft.javascriptreact = web_formatters
      opts.formatters_by_ft.typescriptreact = web_formatters
    end
    opts.default_format_opts = opts.default_format_opts or {}
    opts.default_format_opts.format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    }
  end,
}
