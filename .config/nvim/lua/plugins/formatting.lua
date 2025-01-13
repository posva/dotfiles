---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  "conform.nvim",
  opts = function(_, opts)
    if LazyVim.has_extra("formatting.prettier") then
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- local function web_formatters(bufnr)
      --   return { first(bufnr, "eslint_d", "prettierd", "prettier"), "injected" }
      -- end

      -- local web_formatters = { "eslint_d" }
      local web_formatters = { "prettierd", "eslint_d" }
      -- local web_formatters = { "eslint_d", "prettier" }
      -- local web_formatters = { "prettier", "eslint_d" }

      opts.formatters_by_ft.javascript = web_formatters
      opts.formatters_by_ft.typescript = web_formatters
      opts.formatters_by_ft.javascriptreact = web_formatters
      opts.formatters_by_ft.typescriptreact = web_formatters
    end

    -- opts.log_level = vim.log.levels.DEBUG
    opts.default_format_opts = opts.default_format_opts or {}
    -- opts.default_format_opts.async = false
    opts.default_format_opts.format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    }
  end,
}
