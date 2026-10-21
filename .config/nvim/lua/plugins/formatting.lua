local oxfmt_configs = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }
local oxlint_configs = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
local eslint_configs = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yml",
  ".eslintrc.yaml",
}

---@param ctx conform.Context
local function has(ctx, names)
  return vim.fs.root(ctx.dirname, names) ~= nil
end

---@param ctx conform.Context
local function has_prettier(ctx)
  local config = require("conform").get_formatter_config("prettierd", ctx.buf)
  return config ~= nil and config.cwd(config, ctx) ~= nil
end

local fts = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "astro",
  "json",
  "jsonc",
}

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettierd", "eslint_d", "oxlint" } },
  },
  {
    "conform.nvim",
    opts = function(_, opts)
      -- oxfmt > prettierd > eslint_d only. Projects without any config use oxfmt
      for _, ft in ipairs(fts) do
        opts.formatters_by_ft[ft] = { "oxfmt", "prettierd", "oxlint", "eslint_d" }
      end
      for _, ft in ipairs({ "markdown", "markdown.mdx" }) do
        opts.formatters_by_ft[ft] = { "oxfmt", "prettierd", "eslint_d", "markdownlint-cli2", "markdown-toc" }
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = {
        condition = function(_, ctx)
          return has(ctx, oxfmt_configs) or not (has_prettier(ctx) or has(ctx, eslint_configs))
        end,
      }
      opts.formatters.prettierd = {
        require_cwd = true,
        condition = function(_, ctx)
          return not has(ctx, oxfmt_configs)
        end,
      }
      opts.formatters.oxlint = {
        condition = function(_, ctx)
          return has(ctx, oxlint_configs)
        end,
      }
      -- not `--fix-to-stdout`: configs that log to stdout break its JSON parsing
      -- e.g. @antfu/eslint-config "Detected running in editor"
      opts.formatters.eslint_d = {
        inherit = false,
        -- without a local eslint, eslint_d cannot load the project config
        condition = function(_, ctx)
          local root = vim.fs.root(ctx.dirname, eslint_configs)
          return root ~= nil and vim.uv.fs_stat(root .. "/node_modules/eslint") ~= nil
        end,
        format = function(_, ctx, lines, callback)
          vim.system({ "eslint_d", "--fix-dry-run", "--format", "json", "--stdin", "--stdin-filename", ctx.filename }, {
            cwd = vim.fs.root(ctx.dirname, eslint_configs),
            stdin = table.concat(lines, "\n") .. "\n",
          }, vim.schedule_wrap(function(out)
            local ok, result = pcall(vim.json.decode, (out.stdout or ""):match("([^\n]+)\n*$") or "")
            if not ok or type(result) ~= "table" then
              return callback(vim.trim(out.stderr ~= "" and out.stderr or out.stdout or "eslint_d failed"))
            end
            local output = result[1] and result[1].output
            callback(nil, output and vim.split(output:gsub("\n$", ""), "\n", { plain = true }) or lines)
          end))
        end,
      }
    end,
  },
}
