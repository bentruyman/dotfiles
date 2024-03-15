return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
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
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = { "eslint_d" },
        json = { "prettierd" },
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
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "eslint_d",
        "prettierd",
        "shfmt",
        "stylua",
      },
    },
  },
}
