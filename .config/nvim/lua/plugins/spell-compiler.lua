-- Automatically compile spell files when needed and download missing spell files
---@diagnostic disable: undefined-global
return {
  "nvim-lua/plenary.nvim", -- dependency for file operations
  dependencies = {},
  config = function()
    local Path = require("plenary.path")
    local spelldir = vim.fn.stdpath("config") .. "/spell"

    -- Create spell directory if it doesn't exist
    local spell_path = Path:new(spelldir)
    if not spell_path:exists() then
      spell_path:mkdir()
    end

    -- Languages we want to ensure are available
    local languages = {
      { code = "en", name = "English" },
      { code = "es", name = "Spanish" },
      { code = "fr", name = "French" },
    }

    -- Function to check if a file needs compilation
    local function needs_compilation(filepath)
      -- Extract the base name without extension
      local basename = filepath:match("(.+)%.utf%-8%.add$")
      if not basename then
        return false
      end

      -- Check if .spl file exists
      local spl_file = basename .. ".utf-8.add.spl"
      local spl_path = Path:new(spl_file)

      if not spl_path:exists() then
        return true
      end

      -- Check if .add file is newer than .spl file
      local add_stat = vim.loop.fs_stat(filepath)
      local spl_stat = vim.loop.fs_stat(spl_file)

      return add_stat and spl_stat and add_stat.mtime.sec > spl_stat.mtime.sec
    end

    -- Function to compile a spell file
    local function compile_spell_file(filepath)
      vim.cmd("mkspell! " .. vim.fn.fnameescape(filepath))
      vim.notify("Compiled spell file: " .. vim.fn.fnamemodify(filepath, ":t"), vim.log.levels.INFO)
    end

    -- Function to check if language spell files are missing
    local function is_language_missing(lang_code)
      local spl_file = spelldir .. "/" .. lang_code .. ".utf-8.spl"
      return not Path:new(spl_file):exists()
    end

    -- Function to download language spell files
    local function download_language_files(lang_code)
      vim.cmd("silent! spellget " .. lang_code)
      vim.schedule(function()
        vim.notify("Downloaded " .. lang_code .. " spell files", vim.log.levels.INFO)
      end)
      return true
    end

    -- Function to ensure all required language files are available
    local function ensure_language_files()
      local downloaded_any = false

      for _, lang in ipairs(languages) do
        if is_language_missing(lang.code) then
          vim.notify("Downloading " .. lang.name .. " spell files...", vim.log.levels.INFO)
          if download_language_files(lang.code) then
            downloaded_any = true
          end
        end
      end

      return downloaded_any
    end

    -- Function to scan the spell directory and compile as needed
    local function scan_and_compile()
      if not spell_path:exists() then
        return
      end

      local compiled_any = false
      for _, file in ipairs(vim.fn.glob(spelldir .. "/*.add", false, true)) do
        if needs_compilation(file) then
          compile_spell_file(file)
          compiled_any = true
        end
      end
      return compiled_any
    end

    -- Run on startup - first ensure we have the language files, then compile any .add files
    vim.schedule(function()
      ensure_language_files()
      scan_and_compile()
    end)

    -- Set up autocmd to run when .add files are modified
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.add",
      callback = function(ev)
        local file = ev.match
        if file:match("^" .. vim.fn.escape(spelldir, "\\") .. "/.+%.utf%-8%.add$") then
          compile_spell_file(file)
        end
      end,
      desc = "Automatically compile modified spell files",
    })

    -- Create commands for manual operations
    vim.api.nvim_create_user_command("CompileSpellFiles", function()
      if scan_and_compile() then
        vim.notify("Spell files compilation complete", vim.log.levels.INFO)
      else
        vim.notify("No spell files needed compilation", vim.log.levels.INFO)
      end
    end, { desc = "Compile all spell files that need updating" })

    vim.api.nvim_create_user_command("DownloadSpellFiles", function()
      if ensure_language_files() then
        vim.notify("All spell files downloaded", vim.log.levels.INFO)
      else
        vim.notify("All spell files are already present", vim.log.levels.INFO)
      end
    end, { desc = "Download missing spell files for configured languages" })
  end,
}
