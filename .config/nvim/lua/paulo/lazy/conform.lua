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
      go = { "goimports", "gofmt" },
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
      lua = { "stylua" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
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
    },
  },
}
