local utils = require("utils")

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = function()
      return utils.is_remote_host("github.com")
    end,
    event = "InsertEnter",
    config = true,
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = function()
      return utils.is_remote_host("github.com")
    end,
    config = true,
  },
}
