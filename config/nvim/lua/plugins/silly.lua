return {
  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>xr", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make it rain" },
    },
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
