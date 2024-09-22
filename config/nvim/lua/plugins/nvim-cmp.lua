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
          ["<Tab>"] = cmp.mapping.select_next_item({
            select_behavior = cmp.SelectBehavior.Select,
          }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({
            select_behavior = cmp.SelectBehavior.Select,
          }),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#a6e3a1" })
      vim.opt.completeopt = "menu,menuone,noselect"
      vim.opt.shortmess:append("c")

      require("cmp").setup(opts)
    end,
  },
}
