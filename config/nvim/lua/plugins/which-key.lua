return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      expand = 0,
      preset = "modern",
      icons = {
        rules = {
          { pattern = "lazy", icon = "󰒲", color = "azure" },
          { plugin = "nvim-tree.lua", icon = "󰙅", color = "cyan" },
        },
      },
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>l", group = "lazy" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
