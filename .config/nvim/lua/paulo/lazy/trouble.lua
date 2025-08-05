return {
  {
    "folke/trouble.nvim",
    opts = {
      mode = "diagnostics"
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)"
      },
      {
        "[d",
        "<cmd>Trouble diagnostics next skip_groups=true jump=true<cr>",
      },
      {
        "]d",
        "<cmd>Trouble diagnostics prev skip_groups=true jump=true<cr>",
      }
    }
  }
}
