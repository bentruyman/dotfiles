require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^5",
    import = "astronvim.plugins",
    opts = {
      mapleader = " ",
      maplocalleader = ",",
      icons_enabled = true,
      pin_plugins = nil,
      update_notifications = true,
    },
  },
  { import = "plugins" },
  { import = "community" },
  {
    import = "local",
    dir = "~/.dotfiles/nvim/local",
    cond = function()
      local path = vim.fn.expand "~/.dotfiles/nvim/local"
      return vim.fn.isdirectory(path) == 1
    end,
  },
} --[[@as LazySpec]], {
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
}--[[@as LazyConfig]])
