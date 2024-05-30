return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local nvim_lsp = require("lspconfig")

      return {
        servers = {
          astro = {},
          denols = {
            root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
          },
          eslint = {},
          tsserver = {
            root_dir = nvim_lsp.util.root_pattern("package.json"),
            settings = {
              completions = {
                completeFunctionCalls = true,
              },
            },
            single_file_support = true,
          },
        },
      }
    end,
  },
}
