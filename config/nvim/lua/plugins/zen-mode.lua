return {
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>Z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      plugins = {
        kitty = { enabled = true },
        tmux = { enabled = true },
      },
    },
  },
}
