return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls").builtins
    opts.sources = {
      nls.code_actions.gitsigns,
      nls.formatting.shfmt.with({
        filetypes = { "sh", "zsh" },
      }),
      nls.formatting.stylua,
    }
    return opts
  end,
}
