-- function to generate dashboard center items
local function center_item(icon, desc, key, action)
  return { action = action, desc = "  " .. desc, icon = icon, key = key }
end

return {
  {
    "nvimdev/dashboard-nvim",
    -- enabled = false,
    event = "VimEnter",
    opts = function()
      local logo = [[
                         __________________________
                 __..--/".'                        '.
         __..--""      | |                          |
        /              | |                          |
       /               | |    ___________________   |
      ;                | |   :__________________/:  |
      |                | |   |                 '.|  |
      |                | |   |                  ||  |
      |                | |   |                  ||  |
      |                | |   |                  ||  |
      |                | |   |                  ||  |
      |                | |   |                  ||  |
      |                | |   |                  ||  |
      |                | |   |                  ||  |
      |                | |   |______......-----"\|  |
      |                | |   |_______......-----"   |
      |                | |                          |
      |                | |                          |
      |                | |                  ____----|
      |                | |_____.....----|#######|---|
      |                | |______.....----""""       |
      |                | |                          |
      |. ..            | |   ,                      |
      |... ....        | |  (c ----- """           .'
      |..... ......  |\|_|    ____......------"""|"
      |. .... .......| |""""""                   |
      '... ..... ....| |                         |
        "-._ .....  .| |                         |
            "-._.....| |             ___...---"""'
                "-._.| | ___...---"""
                    """""
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            center_item("", "New file", "n", "enew"),
            center_item("", "Recent files", "r", "Telescope oldfiles"),
            center_item("", "Find file", "f", "Telescope find_files"),
            center_item("", "Find text", "g", "Telescope live_grep"),
            center_item("󰒲", "Lazy", "l", "Lazy"),
            center_item("󰶼", "Update plugins", "U", "Lazy update"),
            center_item("", "Quit", "q", "qa"),
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      return opts
    end,
  },
}
