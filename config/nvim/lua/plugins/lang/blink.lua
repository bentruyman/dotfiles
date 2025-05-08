local blink = require("blink.cmp")

local icons = require("lib.icons")

blink.setup({
  appearance = {
    kind_icons = icons.kind,
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
    },
    list = {
      selection = {
        auto_insert = true,
        preselect = false,
      },
    },
    menu = {
      auto_show = function(ctx)
        return ctx.mode ~= "cmdline"
      end,
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
      },
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
    },
  },
  keymap = {
    preset = "super-tab",
  },
  signature = {
    enabled = true,
    window = {
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})
