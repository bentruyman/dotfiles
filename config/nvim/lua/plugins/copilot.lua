local utils = require("utils")

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      if utils.is_remote_host("github.com") then
        require("copilot").setup()
      end
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      if utils.is_remote_host("github.com") then
        require("copilot_cmp").setup()
      end
    end,
  },
}
