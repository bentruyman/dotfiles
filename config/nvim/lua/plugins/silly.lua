return {
  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>sr", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make it rain" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>s"] = { name = "+silly" },
      },
    },
  },
}
