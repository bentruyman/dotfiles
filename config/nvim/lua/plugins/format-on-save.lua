return {
  {
    "elentok/format-on-save.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufWritePre" },
    keys = {
      { "<leader>cf", "<cmd>Format<CR>", desc = "Format" },
    },
    opts = function()
      local formatters = require("format-on-save.formatters")
      local create = require("format-on-save.formatters.create")

      local biome = formatters.if_file_exists({
        pattern = "biome.json",
        formatter = create.shell({
          cmd = {
            "biome",
            "check",
            "--apply-unsafe",
            "--formatter-enabled=true",
            "--organize-imports-enabled=true",
            "--skip-errors",
            "--stdin-file-path",
            "%",
          },
        }),
      })
      local eslint = formatters.if_file_exists({
        pattern = ".eslintrc.*",
        formatter = formatters.eslint_d_fix,
      })
      local fish = create.shell({
        cmd = { "fish_indent" },
      })

      return {
        exclude_path_patterns = {
          "/node_modules/",
          ".local/share/nvim/lazy",
        },
        formatter_by_ft = {
          css = formatters.lsp,
          fish = fish,
          html = formatters.lsp,
          javascript = { biome, eslint },
          javascriptreact = { biome, eslint },
          json = { biome, eslint },
          jsonc = { biome, eslint },
          lua = formatters.stylua,
          markdown = formatters.prettierd,
          rust = formatters.lsp,
          sh = formatters.shfmt,
          typescript = { biome, eslint },
          typescriptreact = { biome, eslint },
          yaml = formatters.lsp,
        },
        fallback_formatter = {
          formatters.remove_trailing_whitespace,
          formatters.remove_trailing_newlines,
        },
      }
    end,
  },
}
