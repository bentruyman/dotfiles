local icons = require("lib.icons")

require("neotest").setup({
  adapters = {
    require("neotest-bun"),
  },
  icons = {
    failed = icons.diagnostics.Error,
    passed = icons.ui.Check,
    running = icons.ui.Play,
    skipped = icons.ui.Minus,
    unknown = icons.diagnostics.Question,
  },
  status = {
    virtual_text = true,
  },
  output = {
    open_on_run = true,
  },
})
