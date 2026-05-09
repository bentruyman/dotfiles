local flit = require("flit")

-- Configure flit with VSCode-aware settings
local config = {
  labeled_modes = "nx",
  -- flit hardcodes the removed `case_sensitive = true` opt, which triggers a
  -- deprecation warning from leap. Override it and use leap's replacement API
  -- to keep f/F/t/T case-sensitive.
  opts = {
    case_sensitive = false,
    vim_opts = { ["go.ignorecase"] = false },
  },
}

-- Add any VSCode-specific configuration if needed
if vim.g.vscode then
  -- For example, you might want to adjust the keys or other settings
  -- config.keys = { f = 'f', F = 'F', t = 't', T = 'T' }
end

flit.setup(config)
