-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local map = vim.keymap.set

local range_ignore_filetypes = { "lua" }
local diff_format = function()
  local data = require("mini.diff").get_buf_data()
  if not data or not data.hunks then
    vim.notify("No hunks in this buffer")
    return
  end
  local format = require("conform").format
  -- stylua range format mass up indent, so use full format for now
  if vim.tbl_contains(range_ignore_filetypes, vim.bo.filetype) then
    format({ lsp_fallback = true, timeout_ms = 500 })
    return
  end
  local ranges = {}
  for _, hunk in pairs(data.hunks) do
    if hunk.type ~= "delete" then
      -- always insert to index 1 so format below could start from last hunk, which this sort didn't mess up range
      table.insert(ranges, 1, {
        start = { hunk.buf_start, 0 },
        ["end"] = { hunk.buf_start + hunk.buf_count, 0 },
      })
    end
  end
  for _, range in pairs(ranges) do
    format({ lsp_fallback = true, timeout_ms = 500, range = range })
  end
end

vim.api.nvim_create_user_command("DiffFormat", diff_format, { desc = "Format changed lines" })
