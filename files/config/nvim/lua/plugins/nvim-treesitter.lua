return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "dockerfile" })
      vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      vim.list_extend(opts.ensure_installed, { "yaml" })
    end
  end,
}
