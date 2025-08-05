return {
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    config = function()
      vim.cmd('colorscheme tokyonight')
      vim.cmd.colorscheme('tokyonight')

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
    end
  }
}
