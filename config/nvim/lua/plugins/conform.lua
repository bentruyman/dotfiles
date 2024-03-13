return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "eslint_d" },
        lua = { "stylua" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
  },
}
