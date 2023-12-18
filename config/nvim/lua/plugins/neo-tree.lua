return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          ".git",
          ".DS_Store",
          "node_modules",
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    },
    use_libuv_file_watcher = true,
  },
}
