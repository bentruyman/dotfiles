return {
  {
    "akinsho/toggleterm.nvim",
    config = true,
    build = ":ToggleTerm",
    keys = {
      { "<C-/>", "<cmd>ToggleTerm size=25<cr>", desc = "ToggleTerm" },
      { "<C-_>", "<cmd>ToggleTerm size=25<cr>", desc = "which_key_ignore" },
    },
  },
}
