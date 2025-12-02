local treesitter = require("nvim-treesitter.configs")
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.tea = {
  install_info = {
    url = "/Users/bentruyman/Development/src/github.com/bentruyman/tea-lang/tree-sitter-tea",
    files = { "src/parser.c" },
  },
  filetype = "tea",
}

vim.opt.runtimepath:append("/Users/bentruyman/Development/src/github.com/bentruyman/tea-lang/tree-sitter-tea")

treesitter.setup({
  modules = {},
  ignore_install = {},
  sync_install = false,
  ensure_installed = {
    "bash",
    "diff",
    "html",
    "javascript",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})
