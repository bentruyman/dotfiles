return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      local nls = require("null-ls")

      local opts = {
        sources = {
          nls.builtins.code_actions.refactoring,
          nls.builtins.completion.spell,
          nls.builtins.diagnostics.fish,
          nls.builtins.diagnostics.gitlint,
        },
      }

      return opts
    end,
  },
}
