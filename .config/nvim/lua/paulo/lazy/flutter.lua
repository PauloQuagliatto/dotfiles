return {
  "akinsho/flutter-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      flutter_path = nil, -- or specify path if not in PATH
      lsp = {
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
      -- Optional: Debugger integration with nvim-dap
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
    })
  end,
}
