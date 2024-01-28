return {
  {
    "catppuccin/nvim",
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        dashboard = true,
        gitsigns = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotree = true,
        noice = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,

  },
}
