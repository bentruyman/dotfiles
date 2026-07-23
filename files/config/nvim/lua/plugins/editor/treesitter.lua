-- The tea parser is built from a local checkout of the tea-lang repo, which is
-- not present on every machine. Skip it entirely when the checkout is missing.
local tea_parser_path = vim.fs.normalize("~/Development/src/github.com/bentruyman/tea-lang/tree-sitter-tea")

local function has_tea_parser_source()
  local uv = vim.uv or vim.loop
  local stat = uv and uv.fs_stat and uv.fs_stat(tea_parser_path) or nil
  return stat ~= nil and stat.type == "directory"
end

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
  "regex",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

local function register_tea_parser()
  require("nvim-treesitter.parsers").tea = {
    install_info = {
      path = tea_parser_path,
      queries = "queries",
    },
    tier = 3,
  }
end

local tea_available = has_tea_parser_source()

if tea_available then
  table.insert(ensure_installed, "tea")
  register_tea_parser()
end

local treesitter = require("nvim-treesitter")
local has_new_api = type(treesitter.install) == "function"

treesitter.setup()

if has_new_api then
  if tea_available then
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = register_tea_parser,
    })
  end

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
