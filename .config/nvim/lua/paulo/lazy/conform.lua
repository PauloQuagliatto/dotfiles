return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({
          async = false,
          lsp_fallback = true,
        })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters = {
      prettier = {
        require_cwd = true,
        prepend_args = { "--config-precedence=prefer-file" },
      },
      biome = {
        require_cwd = true,
        prepend_args = { "--config-precedence=prefer-file" },
      },
    },
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = {
        "biome",
        "biome-organize-imports",
        "prettier",
      },
      javascriptreact = {
        "biome",
        "biome-organize-imports",
        "prettier",
      },
      typescript = {
        "biome",
        "biome-organize-imports",
        "prettier",
      },
      typescriptreact = {
        "biome",
        "biome-organize-imports",
        "prettier",
      },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      python = { "ruff" },
    },
  },
}
