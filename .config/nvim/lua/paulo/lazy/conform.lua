return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        local conform = require("conform")
        local formatters = conform.list_formatters_for_buffer()
        local formatter_names = {}

        for _, formatter in ipairs(formatters) do
          table.insert(formatter_names, formatter.name)
        end

        if #formatter_names > 0 then
          print("Formatter(s): " .. table.concat(formatter_names, ", "))
        else
          print("No formatter configured for this buffer")
        end
        conform.format({
          async = false,
          lsp_fallback = "true",
          lsp_format = "fallback",
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
        args = { "format", "--write", "--stdin-file-path", "$FILENAME" },
        stdin = true,
      },
    },
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      json = { "biome", "biome-organize-imports" },
      jsonc = { "biome", "biome-organize-imports" },
      javascript = { "biome", "biome-organize-imports" },
      javascriptreact = { "biome", "biome-organize-imports" },
      typescript = { "biome", "biome-organize-imports" },
      typescriptreact = { "biome", "biome-organize-imports" },
      go = { "goimports", "gofmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
    },
  },
}
