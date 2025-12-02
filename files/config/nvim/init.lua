-- Detect if running in VSCode
if vim.g.vscode then
  -- VSCode-specific initialization
  local vscode = require("vscode")
  vim.notify = vscode.notify
  
  -- Only load essential configuration for VSCode
  require("core.options")
  -- Load plugins with VSCode-specific setup
  require("plugins.lazy")
else
  -- Regular Neovim initialization
  require("core.keymaps")
  require("core.options")
  require("core.autocmd")
  
  require("plugins.lazy")
end
