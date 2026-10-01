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
      oxfmt_imports = {
        command = "oxfmt",
        args = { "--config", vim.fn.stdpath("config") .. "/oxfmt-imports.json", "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },
      prettier = {
        command = vim.fn.stdpath("data") .. "/mason/packages/prettier/node_modules/.bin/prettier",
      },
    },
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
    },
  },
  config = function(_, opts)
    local web_filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "yaml",
      "markdown",
      "graphql",
    }
    for _, ft in ipairs(web_filetypes) do
      opts.formatters_by_ft[ft] = function(bufnr)
        local tools = require("paulo.web_tools")
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local formatter = tools.formatter(filename)
        -- Biome does not format these filetypes; let Oxfmt handle them.
        if formatter == "biome" and (ft == "scss" or ft == "less" or ft == "yaml" or ft == "markdown") then
          formatter = "oxfmt"
        end
        if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" or ft == "vue" or ft == "svelte" then
          if formatter == "biome" then
            return { "biome-organize-imports", "biome" }
          end
          if formatter == "oxfmt" and not tools.has_oxfmt_config(filename) then
            return { "oxfmt_imports" }
          end
          return { "oxfmt_imports", formatter }
        end
        return { formatter }
      end
    end
    -- Oxfmt does not support Astro files yet.
    opts.formatters_by_ft.astro = function(bufnr)
      local formatter = require("paulo.web_tools").formatter(vim.api.nvim_buf_get_name(bufnr))
      if formatter == "biome" then
        return { "biome-organize-imports", "biome" }
      end
      return { "biome-organize-imports", formatter == "oxfmt" and "prettier" or formatter }
    end
    require("conform").setup(opts)
  end,
}
