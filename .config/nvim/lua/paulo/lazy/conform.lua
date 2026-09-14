return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({
          async = false,
        })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters = {
      biome = {
        command = "biome",
        args = { "format", "--stdin-file-path", "$FILENAME" },
        stdin = true,
      },
      ["biome-organize-imports"] = {
        command = "biome",
        args = {
          "check",
          "--write",
          "--formatter-enabled=false",
          "--linter-enabled=false",
          "--assist-enabled=true",
          "--stdin-file-path",
          "$FILENAME",
        },
        stdin = true,
      },
      prettier = {
        command = vim.fn.stdpath("data") .. "/mason/packages/prettier/node_modules/.bin/prettier",
      },
    },
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "biome", "biome-organize-imports", "prettier" },
      json = { "biome", "biome-organize-imports", "prettier" },
      jsonc = { "biome", "biome-organize-imports", "prettier" },
      javascript = { "biome", "biome-organize-imports", "prettier" },
      javascriptreact = { "biome", "biome-organize-imports", "prettier" },
      typescript = { "biome", "biome-organize-imports", "prettier" },
      typescriptreact = { "biome", "biome-organize-imports", "prettier" },
      -- Biome does not format Vue templates reliably; use Prettier for the
      -- complete single-file component, including its template section.
      vue = { "prettier" },
      go = { "gofmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
    },
  },
}
