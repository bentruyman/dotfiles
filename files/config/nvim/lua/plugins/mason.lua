return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "codelldb" })
      vim.list_extend(opts.ensure_installed, { "js-debug-adapter" })
      vim.list_extend(opts.ensure_installed, { "prettierd" })
    end
  end,
}
