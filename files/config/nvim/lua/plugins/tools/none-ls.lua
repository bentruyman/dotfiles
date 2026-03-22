local null_ls = require("null-ls")
local cmd_resolver = require("null-ls.helpers.command_resolver")

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover

-- Helper to check if oxfmt is a devDependency in package.json
local function has_oxfmt_devdep(utils)
  if not utils.root_has_file("package.json") then
    return false
  end
  -- Get root from cwd or buffer path
  local root = vim.fn.getcwd()
  local path = root .. "/package.json"
  local ok, content = pcall(vim.fn.readfile, path)
  if not ok or not content then
    return false
  end
  local json_str = table.concat(content, "\n")
  local parse_ok, parsed = pcall(vim.fn.json_decode, json_str)
  if not parse_ok or not parsed then
    return false
  end
  local dev_deps = parsed.devDependencies or {}
  return dev_deps["oxfmt"] ~= nil
end

-- Custom oxfmt formatter using CLI (since LSP formatting is broken)
local oxfmt = {
  name = "oxfmt",
  method = null_ls.methods.FORMATTING,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  generator = null_ls.formatter({
    command = "oxfmt",
    dynamic_command = cmd_resolver.from_node_modules(),
    args = { "--stdin-filepath", "$FILENAME" },
    to_stdin = true,
    condition = function(utils)
      return has_oxfmt_devdep(utils)
    end,
  }),
}

null_ls.setup({
  sources = {
    code_actions.refactoring,

    completion.spell,
    completion.tags,

    formatting.prettierd.with({
      -- Disable prettierd for filetypes where oxfmt might be used
      -- oxfmt will take precedence via condition check
      condition = function(utils)
        return not has_oxfmt_devdep(utils)
      end,
    }),
    formatting.shfmt,
    formatting.stylua,
    formatting.swift_format,
    oxfmt,

    hover.dictionary,
    hover.printenv,
  },
})

local ensure_installed = require("plugins.list").null_ls_sources

require("mason-null-ls").setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})
