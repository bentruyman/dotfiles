return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = vim.opt.sessionoptions:get(),
    },
    config = function(_, opts)
      require("persistence").setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>x"] = { name = "+silly" },
      },
    },
  },
}
