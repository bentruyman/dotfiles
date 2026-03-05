require("pkl-neovim").init()

-- Set up snippets
require("luasnip.loaders.from_snipmate").lazy_load()

vim.g.pkl_neovim = {
  start_command = { "pkl-lsp" },
  pkl_cli_path = vim.fn.exepath("pkl"),
}
