return {
  -- NOTE: decomment if ai.lua with avante is enabled
  "saghen/blink.cmp",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      accept = {
        -- it has bugs like <c-n> not working to cycle through completions
        dot_repeat = false,
      },
    },
  },
  -- sources = {
  --   providers = {
  --     avante_commands = {
  --       name = "avante_commands",
  --       module = "blink.compat.source",
  --       score_offset = 90, -- show at a higher priority than lsp
  --       opts = {},
  --     },
  --     avante_files = {
  --       name = "avante_commands",
  --       module = "blink.compat.source",
  --       score_offset = 100, -- show at a higher priority than lsp
  --       opts = {},
  --     },
  --     avante_mentions = {
  --       name = "avante_mentions",
  --       module = "blink.compat.source",
  --       score_offset = 1000, -- show at a higher priority than lsp
  --       opts = {},
  --     },
  --   },
  --   -- adding any nvim-cmp sources here will enable them
  --   -- with blink.compat
  --   compat = {
  --     "avante_commands",
  --     "avante_mentions",
  --     "avante_files",
  --   },
  --   default = { "lsp", "path", "snippets", "buffer" },
  --   cmdline = {},
  -- },
}
