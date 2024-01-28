return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ct", "<cmd>TroubleToggle<cr>", desc = "Trouble" },
    },
    config = true,
  },
}
