local util = {}

util.get_git_remote = function()
  local remote = vim.fn.system("git config --get remote.origin.url")
  remote = remote:gsub("^%s*(.-)%s*$", "%1")
  return remote
end

util.get_user_config = function(key, default)
  local status_ok, user_config = pcall(require, "user")

  if not status_ok then
    return default
  end

  local value = user_config[key]
  if value == nil then
    return default
  end

  return value
end

local root_files = { ".git", ".hg", ".svn", "package.json" }
util.root_dir = function(dir)
  local root = vim.fs.find(root_files, { upward = true, limit = 1, path = dir })[1] or ""
  return vim.fs.dirname(root)
end

util.to_set = function(keys)
  local m = {}
  for _, k in ipairs(keys) do
    m[k] = true
  end
  return m
end

return util
