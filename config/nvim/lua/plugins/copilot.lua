local utils = require("utils")

return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = { "zbirenbaum/copilot-cmp", config = true },
    enabled = function()
      return utils.is_remote_host("github.com")
    end,
    event = "InsertEnter",
    opts = {
      filetypes = {
        markdown = true,
        yaml = true,
      },
      panel = { enabled = false },
      suggestion = { enabled = false },
    },
  },
}
