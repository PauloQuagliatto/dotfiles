return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      -- Python Setup
      local python_path = table.concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python" }, "/"):gsub("//+", "/")
      dap_python.setup(python_path)

      -- Dart / Flutter Setup
      dap.adapters.dart = {
        type = "executable",
        command = "flutter",
        args = { "debug_adapter" },
      }

      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          dartSdkPath = os.getenv("HOME") .. "/flutter/bin/cache/dart-sdk",
          flutterSdkPath = os.getenv("HOME") .. "/flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        },
      }

      -- TypeScript / JavaScript Setup (Base)
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      -- pwa-chrome adapter for React/Vue client-side debugging
      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      dap.adapters["node"] = function(cb, config)
        if config.type == "node" then
          config.type = "pwa-node"
        end
        local nativeAdapter = dap.adapters["pwa-node"]
        if type(nativeAdapter) == "function" then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end

      local ts_runtime = vim.fn.executable("tsx") == 1 and "tsx" or "ts-node"

      -- Shared JS/TS configurations (Node backend)
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch File",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = ts_runtime,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node Process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
        }
      end

      -- React Specific Configurations
      -- Uses pwa-chrome to attach to a running dev server (Vite/Create-React-App)
      dap.configurations.javascriptreact = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome (React)",
          url = "http://localhost:5173", -- Default Vite port, change to 3000 for CRA
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "node_modules/**", "**/node_modules/**" },
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "Attach to Chrome (React)",
          url = "http://localhost:5173",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          port = 9222, -- Requires Chrome started with --remote-debugging-port=9222
          skipFiles = { "node_modules/**" },
        },
      }
      -- Merge Node configs into react as well for server-side rendering (Next.js)
      for _, config in ipairs(dap.configurations.typescript) do
        table.insert(dap.configurations.javascriptreact, config)
      end

      -- Vue Specific Configurations
      -- Similar to React, but often uses Vite.
      -- Note: For Vue 3 <script setup>, ensure source maps are enabled in vite.config.ts
      dap.configurations.vue = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome (Vue)",
          url = "http://localhost:5173", -- Default Vite port
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "node_modules/**", "**/dist/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Vite Node (Vue SSR)",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "node_modules/**" },
        },
      }
      -- Also apply TS/JS configs to Vue files for script debugging
      for _, config in ipairs(dap.configurations.typescript) do
        table.insert(dap.configurations.vue, config)
      end

      -- Golang Setup
      dap.adapters.go = function(callback, config)
        if config.request == "attach" then
          callback({
            type = "server",
            host = "127.0.0.1",
            port = config.port or 38697,
          })
        else
          callback({
            type = "server",
            port = "${port}",
            executable = {
              command = "dlv",
              args = { "dap", "-l", "127.0.0.1:${port}" },
              detached = vim.fn.has("win32") == 0,
            },
          })
        end
      end

      dap.configurations.go = {
        {
          type = "go",
          request = "launch",
          name = "Debug Current File",
          program = "${file}",
        },
        {
          type = "go",
          request = "launch",
          name = "Debug Test File",
          mode = "test",
          program = "${file}",
        },
        {
          type = "go",
          request = "launch",
          name = "Debug Package (go.mod)",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      -- Zig Setup
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.zig = {
        {
          name = "Launch Current File",
          type = "codelldb",
          request = "launch",
          program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      -- Sign Definitions
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
  },
}
