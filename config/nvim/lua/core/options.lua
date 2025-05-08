local icons = require("lib.icons")

-- Core Neovim settings
vim.g.mapleader = " " -- Set <Space> as leader key
vim.g.maplocalleader = " " -- Set <Space> as local leader key
vim.g.have_nerd_font = true -- Enable Nerd Font support

-- Diagnostics
vim.diagnostic.config({
  float = true,
  severity_sort = true,
  update_in_insert = true,
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
    },
  },
})

-- Editor options
local options = {
  autowrite = true,
  breakindent = true,
  colorcolumn = "80",
  confirm = true, -- Confirm to save changes before exiting
  cursorline = true, -- Highlight the current line
  ignorecase = true, -- Ignore case in search patterns
  inccommand = "split", -- Show live preview of :s results
  list = true, -- Show invisible characters
  listchars = { tab = "» ", trail = "·", nbsp = "␣" }, -- Characters for invisible chars
  mouse = "a", -- Enable mouse support
  number = true, -- Show line numbers
  relativenumber = true, -- Show relative line numbers
  scrolloff = 10, -- Minimum lines above/below cursor
  showmode = false, -- Don't show mode (e.g. -- INSERT --)
  signcolumn = "yes", -- Always show the sign column
  smartcase = true, -- Override ignorecase if search contains capitals
  splitbelow = true, -- Horizontal splits open below
  splitright = true, -- Vertical splits open to the right
  termguicolors = true, -- Enable 24-bit RGB color in the TUI
  timeoutlen = 300, -- Time to wait for a mapped sequence (ms)
  undofile = true, -- Save undo history to file
  updatetime = 50, -- Faster completion (default is 4000ms)
  wildmode = "longest:full,full", -- Command line completion mode
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
end)
