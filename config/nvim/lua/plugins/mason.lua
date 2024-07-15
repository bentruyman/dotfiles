return {
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>mm", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>mu", "<cmd>MasonUpdate<cr>", desc = "Mason Update" },
    },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "shfmt", "stylua" })
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      table.insert(opts.spec, { "<leader>m", group = "mason", icon = { icon = "", color = "orange" } })
    end,
  },
}
