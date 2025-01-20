return {
  "philosofonusus/ecolog.nvim",
  -- dependencies = {
  --   "hrsh7th/nvim-cmp", -- Optional: for autocompletion support (recommended)
  -- },
  -- Optional: you can add some keybindings
  -- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
  keys = {
    { "<leader>fv", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "<leader>ue", "<cmd>EcologShelterToggle<cr>", desc = "Toggle .env cloak" },
    -- { "<leader>gep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
    -- { "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
  },
  -- Lazy loading is done internally
  lazy = false,
  opts = {
    integrations = {
      -- WARNING: for both cmp integrations see readme section below
      nvim_cmp = false, -- If you dont plan to use nvim_cmp set to false, enabled by default
      -- If you are planning to use blink cmp uncomment this line
      blink_cmp = true,
    },
    -- Enables shelter mode for sensitive values
    shelter = {
      configuration = {
        partial_mode = {
          show_start = 2, -- Show first 3 characters
          show_end = 2, -- Show last 3 characters
          min_mask = 3, -- Minimum masked characters
        },
        -- mask_char = "●",
        mask_char = "*",
      },
      modules = {
        cmp = true, -- Enabled to mask values in completion
        peek = true, -- Enable to mask values in peek view
        files = true, -- Enabled to mask values in file buffers
        telescope = false, -- Enable to mask values in telescope integration
        telescope_previewer = false, -- Enable to mask values in telescope preview buffers
        fzf = true, -- Enable to mask values in fzf picker
        fzf_previewer = true, -- Enable to mask values in fzf preview buffers
        snacks_previewer = false, -- Enable to mask values in snacks previewer
        snacks = false, -- Enable to mask values in snacks picker
      },
    },
    -- true by default, enables built-in types (database_url, url, etc.)
    types = true,
    path = vim.fn.getcwd(), -- Path to search for .env files
    preferred_environment = "development", -- Optional: prioritize specific env files
    -- Controls how environment variables are extracted from code and how cmp works
    provider_patterns = true, -- true by default, when false will not check provider patterns
  },
}
