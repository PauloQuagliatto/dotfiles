return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        graphql = { 'prettier' },
        lua = { 'stylua' },
        python = { 'ruff' }
      }
    })

    vim.keymap.set("n", "<leader>f", function()
      require('conform').format({
        lsp_fallback = true,
        async = false
      })
    end)
  end
}
