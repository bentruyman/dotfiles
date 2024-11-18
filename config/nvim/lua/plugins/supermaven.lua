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
    config = function()
      local supermaven = require("supermaven-nvim")

      supermaven.setup({
        color = {
          suggestion_color = "#f38ba8",
          cterm = 244,
        },
        condition = function()
          return not utils.is_remote_host("github.com")
        end,
        disable_inline_completion = true,
        disable_keymaps = true,
        log_level = "off",
      })
    end,
  },
}
