return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
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
        args = { "format", "--write", "--stdin-file-path", "$FILENAME" },
        stdin = true,
        condition = function(ctx)
          local config_files = { "biome.json", "biome.jsonc" }
          local dir = ctx.dirname
          while dir and dir ~= "" do
            for _, file in ipairs(config_files) do
              if vim.fn.filereadable(dir .. "/" .. file) == 1 then
                return true
              end
            end
            local parent = vim.fn.fnamemodify(dir, ":h")
            if parent == dir then
              break
            end
            dir = parent
          end
          return false
        end,
      },
      ["biome-organize-imports"] = {
        command = "biome",
        args = { "check --write --unsafe --stdin-file-path", "$FILENAME" },
        stdin = true,
        condition = function(ctx)
          local config_files = { "biome.json", "biome.jsonc" }
          local dir = ctx.dirname
          while dir and dir ~= "" do
            for _, file in ipairs(config_files) do
              if vim.fn.filereadable(dir .. "/" .. file) == 1 then
                return true
              end
            end
            local parent = vim.fn.fnamemodify(dir, ":h")
            if parent == dir then
              break
            end
            dir = parent
          end
          return false
        end,
      },
      prettier = {
        condition = function(ctx)
          local config_files = {
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }
          local dir = ctx.dirname
          while dir and dir ~= "" do
            for _, file in ipairs(config_files) do
              if vim.fn.filereadable(dir .. "/" .. file) == 1 then
                return true
              end
            end
            local parent = vim.fn.fnamemodify(dir, ":h")
            if parent == dir then
              break
            end
            dir = parent
          end
          return false
        end,
      },
    },
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "biome", "biome-organize-imports" },
      json = { "biome", "biome-organize-imports" },
      jsonc = { "biome", "biome-organize-imports" },
      javascript = { "biome", "biome-organize-imports" },
      javascriptreact = { "biome", "biome-organize-imports" },
      typescript = { "biome", "biome-organize-imports" },
      typescriptreact = { "biome", "biome-organize-imports" },
      vue = { "biome", "biome-organize-imports", "prettier" },
      go = { "goimports", "gofmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
      vue = { "prettierd", "vuels" },
    },
  },
}
