local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.editor.leap" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    -- { import = "lazyvim.plugins.extras.lang.json" }, -- disabled for biome compatibility
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.vscode" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  ui = {
    border = "rounded",
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
