return {
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>Z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        kitty = { enabled = true },
        tmux = { enabled = true },
      },
      window = {
        options = {
          relativenumber = false,
        },
      },
    },
  },
}
