vim.opt.runtimepath:append("/Users/bentruyman/Development/src/github.com/bentruyman/tea-lang/tree-sitter-tea")

require("nvim-treesitter").setup({
  ensure_installed = {
    "bash",
    "diff",
    "html",
    "javascript",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "pkl",
    "query",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
  },
  auto_install = true,
})
