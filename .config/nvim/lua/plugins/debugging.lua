return {
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      -- Debug UI toggle
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle Debug UI",
      },
      -- Step over
      {
        "<F8>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      -- Step into
      {
        "<F7>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      -- Step out
      {
        "<S-F8>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      -- Continue
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      -- Add debug launch keybinding
      {
        "<leader>dL",
        function()
          require("dap").run({ type = "codelldb", request = "launch", name = "Debug Current File" })
        end,
        desc = "Debug Current File",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Initialize DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Open/close UI automatically
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Setup highlighting
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })

      -- Highlight the line where execution is stopped
      vim.api.nvim_set_hl(0, "DapStopped", { bg = "#2d3142" })

      -- Setup for Zig debugging with codelldb
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.zig = {
        {
          name = "Debug Current File",
          type = "codelldb",
          request = "launch",
          -- Replace this function in plugins/debugging.lua
          program = function()
            local source_file = vim.fn.expand("%:t") -- Just the filename
            local project_root = vim.fn.getcwd() -- Current working directory
            local binary = vim.fn.expand("%:t:r") -- Filename without extension

            -- Use zig build first (preferred with build.zig)
            local build_cmd = string.format("cd %s && zig build", project_root)
            local build_output = vim.fn.system(build_cmd)

            if vim.v.shell_error ~= 0 then
              -- If zig build fails, try direct compilation
              local compile_cmd = string.format(
                "cd %s && zig build-exe %s -femit-bin=%s -g",
                project_root,
                vim.fn.expand("%:p"), -- Full path to current file
                binary
              )
              local compile_output = vim.fn.system(compile_cmd)

              if vim.v.shell_error ~= 0 then
                vim.notify("Failed to compile: " .. compile_output, vim.log.levels.ERROR)
                return nil
              end

              vim.notify("Direct compilation successful!", vim.log.levels.INFO)
              return project_root .. "/" .. binary
            end

            -- If zig build succeeded, use the binary from zig-out
            vim.notify("Zig build successful!", vim.log.levels.INFO)
            local project_name = vim.fn.fnamemodify(project_root, ":t")
            return project_root .. "/zig-out/bin/" .. project_name
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
          sourceLanguages = { "zig" },
        },
      }
    end,
  },
}
