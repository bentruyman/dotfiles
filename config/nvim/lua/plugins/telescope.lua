return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    keys = {
      {
        "<leader><space>",
        function()
          local method = "find_files"
          local opts = {}

          if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
            opts.show_untracked = true
            method = "git_files"
          end

          require("telescope.builtin")[method](opts)
        end,
        desc = "Find files",
      },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find text", },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enabled = vim.fn.executable("make") == 1,
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
