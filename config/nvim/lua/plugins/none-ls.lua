return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls").builtins
    opts.sources = {
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
      nls.formatting.shfmt.with({
        filetypes = { "sh", "zsh" },
      }),
      nls.formatting.stylua,
    }
    return opts
  end,
}
