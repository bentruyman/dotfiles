---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<C-_>"] = { "<Cmd>ToggleTerm size=20 direction=horizontal<CR>", desc = "Toggle terminal" },
          ["<Leader><Space>"] = { function() require("snacks").picker.git_files() end, desc = "Find git files" },
          ["<Leader>Z"] = { "<Cmd>ZenMode<CR>", desc = "Zen Mode" },
        },
        t = {
          ["<C-_>"] = { "<Cmd>close<CR>", desc = "Close terminal" },
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = 20,
    },
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = true },
      },
      window = {
        options = {
          relativenumber = false,
        },
      },
    },
  },
  { "overleaf/vim-env-syntax" },
  {
    "package-info.nvim",
    enabled = false,
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    opts = {
      keymaps = {
        accept_suggestion = "<C-l>",
        clear_suggestion = "<C-h>",
        accept_word = "<C-e>",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "gofumpt", "goimports", lsp_format = "last" },
      },
    },
  },
  {
    "tpope/vim-surround",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "gofumpt", "golangci-lint-langserver" })
    end,
  },
}
