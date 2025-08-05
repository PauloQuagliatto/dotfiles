return {
  'norcalli/nvim-colorizer.lua',
  config = function()
      require('colorizer').setup({
      '*',
      typescript = {
          css = true
      },
      javascript = {
          css = true
      },
      html = {
          css = true
      },
      css = {
          css = true,
          css_fn = true
      }
    })
  end
}
