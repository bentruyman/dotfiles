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

return util
