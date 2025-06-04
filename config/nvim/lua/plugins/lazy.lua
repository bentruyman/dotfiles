local icons = require("lib.icons")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

local plugins = require("plugins.list").plugins

lazy.setup({
  -- defaults = { lazy = true },
  defaults = { lazy = false },
  install = {
    colorscheme = { "catppuccin-mocha" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "zipPlugin",
        "tohtml",
      },
    },
  },
  spec = plugins,
  ui = {
    border = "rounded",
    icons = {
      cmd = icons.ui.Terminal,
      config = icons.ui.Gear,
      event = icons.ui.Electric,
      ft = icons.ui.File,
      init = icons.ui.Rocket,
      import = icons.ui.Import,
      keys = icons.ui.Keyboard,
      lazy = icons.ui.Sleep,
      loaded = icons.ui.CircleSmall,
      not_loaded = icons.ui.CircleSmallEmpty,
      plugin = icons.ui.Package,
      runtime = icons.ui.Neovim,
      source = icons.ui.Code,
      start = icons.ui.Play,
      task = icons.ui.Check,
      list = {
        icons.ui.CircleSmall,
        icons.ui.Arrow,
        icons.ui.Star,
        icons.ui.Minus,
      },
    },
  },
})
