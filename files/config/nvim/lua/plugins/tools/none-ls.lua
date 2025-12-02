local null_ls = require("null-ls")

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover

null_ls.setup({
  sources = {
    code_actions.refactoring,

    completion.spell,
    completion.tags,

    formatting.prettierd,
    formatting.shfmt,
    formatting.stylua,
    formatting.swift_format,

    hover.dictionary,
    hover.printenv,
  },
})

local ensure_installed = require("plugins.list").null_ls_sources

require("mason-null-ls").setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})
