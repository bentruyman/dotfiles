return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Personal",
        path = "~/Library/Mobile Documents/com~apple~CloudDocs/Notes",
      },
      {
        name = "Work",
        path = "~/Library/Mobile Documents/com~apple~icloud~applecorporate/Documents/Notes",
      },
    },
  },
}
