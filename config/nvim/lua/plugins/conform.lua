-- Check if the current directory has an ESLint config
local function is_eslint_project()
  local eslint_config_files = { ".eslintrc.js", ".eslintrc.json", "package.json" }
  for _, file in ipairs(eslint_config_files) do
    if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
      if file == "package.json" then
        local package_json = vim.fn.json_decode(vim.fn.readfile("package.json"))
        if package_json.devDependencies and package_json.devDependencies.eslint then
          return true
        elseif package_json.dependencies and package_json.dependencies.eslint then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end

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
        javascript = { "eslint_d", "prettierd" },
        javascriptreact = { "eslint_d", "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        typescript = { "eslint_d", "prettierd" },
        typescriptreact = { "eslint_d", "prettierd" },
      },
      formatters = {
        eslint_d = {
          condition = is_eslint_project,
        },
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
