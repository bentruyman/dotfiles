return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      return {
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            max_width = 50,
            symbol_map = { Supermaven = "" },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "supermaven" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },
}
