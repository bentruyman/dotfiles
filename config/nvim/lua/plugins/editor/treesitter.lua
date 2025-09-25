local treesitter = require('nvim-treesitter.configs')

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
