return {
  {
    "f-person/git-blame.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
    },
    config = function()
      require("gitblame").setup({ enabled = false })
    end,
  },
}
