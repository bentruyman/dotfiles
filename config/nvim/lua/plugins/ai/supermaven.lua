local supermaven = require("supermaven-nvim")
local util = require("lib.util")
local persistence = require("lib.persistence")

-- Check if Supermaven is enabled (default to true)
local is_enabled = persistence.get("supermaven_enabled", true)

-- Only check git remotes if enabled
if is_enabled then
  local allowed_remotes = {
    "git@github.com",
    "https://github.com",
  }

  local git_remote = util.get_git_remote()
  local is_allowed = false

  for _, remote_pattern in ipairs(allowed_remotes) do
    if string.find(git_remote, remote_pattern) then
      is_allowed = true
      break
    end
  end

  if not is_allowed then
    return
  end
else
  -- If disabled, don't setup Supermaven
  return
end

supermaven.setup({
  keymaps = {
    accept_suggestion = "<C-l>",
    clear_suggestion = "<C-h>",
    accept_word = "<C-e>",
  },
})
