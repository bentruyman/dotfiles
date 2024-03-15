return {
  {
    "williamboman/mason.nvim",
    config = true,
    keys = {
      { "<leader>mm", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>mu", "<cmd>MasonUpdate<cr>", desc = "Mason Update" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>m"] = { name = "+mason" },
      },
    },
  },
}
