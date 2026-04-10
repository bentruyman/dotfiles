local tea_parser_path = "/Users/bentruyman/Development/src/github.com/bentruyman/tea-lang/tree-sitter-tea"

local ensure_installed = {
  "bash",
  "diff",
  "html",
  "javascript",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "tea",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

vim.opt.runtimepath:append(tea_parser_path)

require("nvim-treesitter.parsers").tea = {
  install_info = {
    path = tea_parser_path,
    files = { "src/parser.c" },
    generate_requires_npm = false,
  },
  filetype = "tea",
}

local treesitter = require("nvim-treesitter")
local has_new_api = type(treesitter.install) == "function"

treesitter.setup()

if has_new_api then
  treesitter.install(ensure_installed)

  local treesitter_group = vim.api.nvim_create_augroup("bentruyman-treesitter", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = treesitter_group,
    callback = function(args)
      if not pcall(vim.treesitter.start, args.buf) then
        return
      end

      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
else
  require("nvim-treesitter.configs").setup({
    ensure_installed = ensure_installed,
    auto_install = true,
    highlight = {
      enable = true,
    },
  })
end
