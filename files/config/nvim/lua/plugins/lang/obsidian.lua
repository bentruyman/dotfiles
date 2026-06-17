-- Workspaces are machine-specific, so they live outside this repo.
-- Create ~/.dotfiles/nvim/obsidian.lua that returns a table, e.g.:
--
--   return {
--     workspaces = {
--       { name = "personal", path = "~/Documents/Obsidian Vault" },
--     },
--   }
local local_config = {}
local local_config_path = vim.fn.expand("~/.dotfiles/nvim/obsidian.lua")
if vim.fn.filereadable(local_config_path) == 1 then
  local ok, result = pcall(dofile, local_config_path)
  if ok and type(result) == "table" then
    local_config = result
  end
end

require("obsidian").setup({
  legacy_commands = false,

  workspaces = local_config.workspaces or {},

  completion = {
    nvim_cmp = false,
    blink = true,
    min_chars = 2,
  },

  picker = {
    name = "snacks.pick",
  },

  -- render-markdown.nvim handles markdown UI; let it own that.
  ui = { enable = false },

  daily_notes = {
    folder = "dailies",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
  },

  new_notes_location = "current_dir",

  link = {
    style = "wiki",
  },

  search = {
    sort_by = "modified",
    sort_reversed = true,
  },

  attachments = {
    folder = "assets/imgs",
  },
})
