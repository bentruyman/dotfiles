local gitsigns = require("gitsigns")

local icons = require("lib.icons")

gitsigns.setup({
  signs = {
    add = { text = icons.ui.SeparatorLight },
    change = { text = icons.ui.SeparatorLight },
    changedelete = { text = icons.ui.SeparatorLight },
    delete = { text = icons.ui.SeparatorLight },
    topdelete = { text = icons.ui.Topline },
    untracked = { text = icons.ui.SeparatorDashed },
  },
})
