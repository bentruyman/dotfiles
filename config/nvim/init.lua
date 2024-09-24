if vim.env.VSCODE then
  vim.g.vscode = true
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.filetypes")
require("config.keymaps")
require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local spec = {
  { import = "plugins" },
  { import = "plugins.lang" },
}

if vim.g.vscode then
  spec = {
    { import = "plugins.Comment" },
    { import = "plugins.leap" },
    { import = "plugins.none-ls" },
    { import = "plugins.nvim-autopairs" },
    { import = "plugins.vim-sensible" },
    { import = "plugins.vim-surround" },
  }
end

require("lazy").setup({
  spec = spec,
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = not vim.g.vscode },
})
