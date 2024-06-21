return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local nvim_lsp = require("lspconfig")

      local servers = {
        astro = {},
        denols = {
          root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
        },
        eslint = {},
        vtsls = {
          root_dir = nvim_lsp.util.root_pattern("package.json"),
          single_file_support = false,
        },
      }

      opts.servers = opts.servers or {}
      opts.servers = vim.tbl_extend("force", opts.servers, servers)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "javascript",
          "jsdoc",
          "tsx",
          "typescript",
        })
      end
    end,
  },
}
