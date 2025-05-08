local mason = require("mason")

local icons = require("lib.icons")

mason.setup({
  ui = {
    check_outdated_packages_on_open = true,
    border = "rounded",

    icons = {
      package_installed = icons.ui.Gear,
      package_pending = icons.ui.Download,
      package_uninstalled = icons.ui.Plus,
    },
  },
})
