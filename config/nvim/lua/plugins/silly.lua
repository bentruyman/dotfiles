return {
  {
    "eandrju/cellular-automaton.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    keys = {
      { "<leader>xr", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make it rain" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>x", group = "silly", icon = { icon = "󱈔", color = "azure" } })
    end,
  },
}
