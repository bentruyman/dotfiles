return {
  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    opts = {
      integrations = {
        treesitter = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
