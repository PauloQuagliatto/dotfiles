return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.2.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-media-files.nvim'
    },
    config = function()
      require('telescope').load_extension('media_files')
      require("telescope").setup({
        defaults = {
          preview = {
            treesitter = false,
          },
          file_ignore_patterns = { "node_modules", "zig-out" },
          -- wrap_results = true,
          path_display = { shorten = 4 }
        },
        extensions = {
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg" },
            -- find command (defaults to `fd`)
            find_cmd = "rg"
          }
        }
      })


      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope git files' })
      vim.keymap.set("n", "<leader>pws", function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set("n", "<leader>pWs", function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>s', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
    end
  }
}
