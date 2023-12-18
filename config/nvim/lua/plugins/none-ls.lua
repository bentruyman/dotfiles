return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls").builtins
    opts.sources = {
      nls.code_actions.gitsigns,
      -- ts
      nls.formatting.biome.with({
        args = {
          "check",
          "--apply-unsafe",
          "--formatter-enabled=true",
          "--organize-imports-enabled=true",
          "--skip-errors",
          "$FILENAME",
        },
      }),
      -- other
      nls.formatting.stylua,
      nls.formatting.shfmt.with({
        filetypes = { "sh", "zsh" },
      }),
    }
    return opts
  end,
}
