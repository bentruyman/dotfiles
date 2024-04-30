return {
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>e",
        "<cmd>NvimTreeToggle<cr>",
        desc = "NvimTree (root dir)",
      },
      {
        "<leader>f",
        "<cmd>NvimTreeFocus<cr>",
        desc = "NvimTree focus",
      },
    },
    opts = {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      filters = {
        custom = {
          "^.git$",
        },
      },
      renderer = {
        full_name = true,
        group_empty = true,
        icons = {
          git_placement = "signcolumn",
        },
        indent_markers = {
          enable = true,
        },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = { "help" },
      },
      view = {
        adaptive_size = true,
        side = "right",
      },
    },
    config = true,
  },
}
