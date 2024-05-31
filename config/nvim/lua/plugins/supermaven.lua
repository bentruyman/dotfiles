local utils = require("utils")

return {
  -- TODO: figure out how to get this to work with the config here
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     table.insert(opts.sources, 1, {
  --       name = "supermaven",
  --     })
  --   end,
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = function()
      return utils.is_remote_host("github.com")
    end,
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
