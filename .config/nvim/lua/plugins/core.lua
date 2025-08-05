return {
  {
    "LazyVim/LazyVim",
    -- FIXME: remove once https://github.com/LazyVim/LazyVim/pull/6053 gets merged
    url = "https://github.com/dpetka2001/LazyVim",
    branch = "fix/mason-v2",
    ---@type table<string, string[]|boolean>?
    opts = {

      kind_filter = {
        default = {
          "Class",
          "Constant",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
          "Variable",
        },
        markdown = false,
        help = true,
        -- you can specify a different filter for each filetype
        lua = {
          "Class",
          "Constructor",
          "Constant",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          -- "Package", -- remove package since luals uses it for control flow structures
          "Property",
          "Struct",
          "Trait",
          "Variable",
        },
      },
    },
  },
}
