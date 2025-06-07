local flit = require("flit")

-- Configure flit with VSCode-aware settings
local config = {
  labeled_modes = "nx",
}

-- Add any VSCode-specific configuration if needed
if vim.g.vscode then
  -- For example, you might want to adjust the keys or other settings
  -- config.keys = { f = 'f', F = 'F', t = 't', T = 'T' }
end

flit.setup(config)
