local utils = require("utils")

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "supermaven-inc/supermaven-nvim",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "supermaven" })
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    cond = function()
      return utils.is_remote_host("github.com")
    end,
    config = function()
      require("supermaven-nvim").setup({
        color = {
          suggestion_color = "#f38ba8",
          cterm = 244,
        },
        disable_inline_completion = true,
        disable_keymaps = true,
        log_level = "off",
      })
    end,
  },
}
