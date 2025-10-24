local util = require("lib.util")

local function load_config(plugin)
  return function()
    require("plugins." .. plugin)
  end
end

-- LSP servers that should be installed via Mason
local lsp_servers = {
  bashls = true,
  cssls = true,
  html = true,
  jsonls = function()
    return {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  mdx_analyzer = true,
  vtsls = {
    settings = {
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = true },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "all" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = true },
        },
      },
      vtsls = {
        enableMoveToFileCodeAction = true,
      },
    },
  },
  yamlls = function()
    return {
      settings = {
        yaml = {
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    }
  end,
}

-- LSP servers that are installed system-wide (not via Mason)
local system_lsp_servers = {
  sourcekit = true, -- Comes with Xcode on macOS
}

local null_ls_sources = {
  "shellcheck",
}

local plugins = {}

local shared_plugins = {
  -- Text manipulation plugins
  {
    "tpope/vim-surround",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = load_config("editor.comment"),
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },

  -- Motion/navigation plugins
  {
    "ggandor/flit.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { { "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } } },
    config = load_config("editor.flit"),
  },

  -- Core editing enhancements
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = load_config("editor.treesitter"),
  },
}

local neovim_only_plugins = {
  -- UI
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = load_config("ui.catppuccin"),
  },
  {
    "davidmh/mdx.nvim",
    ft = { "mdx" },
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    keys = function()
      local Snacks = require("snacks")

      return {
        -- stylua: ignore start

        -- Buffers
        { "<leader>bc", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers", },
        { "<leader>bd", function() Snacks.bufdelete() end,       desc = "Delete Buffer", },
        { "<leader>bD", function() Snacks.bufdelete.all() end,   desc = "Delete All Buffers", },
        -- Explorer
        {
          "<leader>e",
          function()
            Snacks.explorer()
            vim.defer_fn(function() vim.cmd("tabdo wincmd =") end, 25)
          end,
          desc = "Open File Explorer",
        },
        {
          "<leader>o",
          function()
            local explorer = Snacks.picker.get({ source = "explorer" })[1]
            if explorer then
              explorer:focus()
            else
              Snacks.explorer()
            end
          end,
          desc = "Focus File Explorer",
        },
        -- Finders
        { "<leader><space>", function() Snacks.picker.smart() end,                desc = "Find Files (Smart)", },
        { "<leader>fb",      function() Snacks.picker.buffers() end,              desc = "Find Buffers", },
        { "<leader>ff",      function() Snacks.picker.files() end,                desc = "Find Files", },
        { "<leader>fg",      function() Snacks.picker.git_files() end,            desc = "Find Git Files", },
        { "<leader>fp",      function() Snacks.picker.projects() end,             desc = "Find Projects", },
        { "<leader>fr",      function() Snacks.picker.recent() end,               desc = "Find Recent", },
        { "<leader>fw",      function() Snacks.picker.grep() end,                 desc = "Find Word", },
        -- Git
        { "<leader>gb",      function() Snacks.picker.git_branches() end,         desc = "Git Branches", },
        { "<leader>gd",      function() Snacks.picker.git_diff() end,             desc = "Git Diff (Hunks)", },
        { "<leader>gl",      function() Snacks.picker.git_log() end,              desc = "Git Log", },
        { "<leader>gL",      function() Snacks.picker.git_log_line() end,         desc = "Git Log Line", },
        { "<leader>gS",      function() Snacks.picker.git_stash() end,            desc = "Git Stash", },
        { "<leader>gs",      function() Snacks.picker.git_status() end,           desc = "Git Status", },
        -- History
        { "<leader>hc",      function() Snacks.picker.command_history() end,      desc = "Command History", },
        { "<leader>hn",      function() Snacks.picker.notifications() end,        desc = "Notification History", },
        -- LSP
        { "gd",              function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition", },
        { "gD",              function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration", },
        { "gr",              function() Snacks.picker.lsp_references() end,       nowait = true,                 desc = "References", },
        { "gI",              function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation", },
        { "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition", },
        -- Terminal
        { "<c-/>",           function() Snacks.terminal() end,                    desc = "Terminal", },
        { "<c-_>",           function() Snacks.terminal() end,                    desc = "which_key_ignore", },
        -- Zen
        { "<leader>z",       function() Snacks.zen() end,                         desc = "Zen Mode", },
        { "<leader>Z",       function() Snacks.zen.zoom() end,                    desc = "Zen Mode (Zoom)", },

        -- stylua: ignore end
      }
    end,
    config = load_config("ui.snacks"),
  },
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "catppuccin/nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = load_config("ui.bufferline"),
  },
  { "Bekaboo/deadcolumn.nvim", lazy = false },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = load_config("ui.gitsigns"),
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = load_config("ui.lualine"),
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    config = true,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = false,
    event = "VeryLazy",
    priority = 1000,
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = load_config("ui.which-key"),
  },

  -- AI plugins
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = load_config("ai.supermaven"),
  },

  -- Diagnostics
  {
    "folke/trouble.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    config = true,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = load_config("lang.lspconfig"),
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter" },
    version = "*",
    dependencies = {
      {
        "saghen/blink.compat",
        version = "*",
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    config = load_config("lang.blink"),
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = load_config("lang.lazydev"),
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Doc" },
    },
    config = load_config("lang.lspsaga"),
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>pm", "<cmd>Mason<CR>", desc = "Mason" },
    },
    config = load_config("lang.mason"),
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = {},
  },

  -- Tools
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = load_config("tools.none-ls"),
  },
}

if vim.g.vscode then
  plugins = shared_plugins
else
  plugins = vim.list_extend(shared_plugins, neovim_only_plugins)
end

lsp_servers = vim.tbl_extend("force", lsp_servers, util.get_user_config("lsp_servers", {}))
system_lsp_servers = vim.tbl_extend("force", system_lsp_servers, util.get_user_config("system_lsp_servers", {}))
null_ls_sources = vim.tbl_extend("force", null_ls_sources, util.get_user_config("null_ls_sources", {}))
plugins = vim.list_extend(plugins, util.get_user_config("plugins", {}))

local all_lsp_servers = vim.tbl_extend("force", lsp_servers, system_lsp_servers)

local final_lsp_servers = vim.g.vscode and {} or all_lsp_servers
local final_mason_servers = vim.g.vscode and {} or lsp_servers
local final_null_ls_sources = vim.g.vscode and {} or null_ls_sources

return {
  lsp_servers = final_lsp_servers,
  mason_lsp_servers = final_mason_servers,
  null_ls_sources = final_null_ls_sources,
  plugins = plugins,
}
