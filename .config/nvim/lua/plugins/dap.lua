return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
    },
    opts = function()
      local dap = require("dap")
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = 'Start Chrome with "localhost"',
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
          },
        }
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      virt_text_win_col = 80,
    },
  },
}
