local M = {}

local state_file = vim.fn.stdpath("data") .. "/nvim_persistence.json"

-- Load persisted state
M.load = function()
  local file = io.open(state_file, "r")
  if not file then
    return {}
  end

  local content = file:read("*all")
  file:close()

  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= "table" then
    return {}
  end

  return data
end

-- Save state to disk
M.save = function(data)
  local ok, json = pcall(vim.json.encode, data)
  if not ok then
    vim.notify("Failed to encode persistence data", vim.log.levels.ERROR)
    return false
  end

  local file = io.open(state_file, "w")
  if not file then
    vim.notify("Failed to open persistence file for writing", vim.log.levels.ERROR)
    return false
  end

  file:write(json)
  file:close()

  return true
end

-- Get a specific value
M.get = function(key, default)
  local data = M.load()
  local value = data[key]
  if value == nil then
    return default
  end
  return value
end

-- Set a specific value
M.set = function(key, value)
  local data = M.load()
  data[key] = value
  return M.save(data)
end

-- Toggle a boolean value
M.toggle = function(key, default)
  local current = M.get(key, default)
  local new_value = not current
  M.set(key, new_value)
  return new_value
end

-- Specific toggle function for Supermaven
M.toggle_supermaven = function()
  local new_state = M.toggle("supermaven_enabled", true)

  if new_state then
    local ok, api = pcall(require, "supermaven-nvim.api")
    if ok and api and api.stop then
      api.start()
      vim.notify("Supermaven enabled", vim.log.levels.INFO)
    else
      vim.notify("Supermaven enabled (will take effect on next restart)", vim.log.levels.INFO)
    end
  else
    -- Try to stop supermaven if it's currently running
    local ok, api = pcall(require, "supermaven-nvim.api")
    if ok and api and api.stop then
      api.stop()
      vim.notify("Supermaven disabled", vim.log.levels.INFO)
    else
      vim.notify("Supermaven disabled (will take full effect on next restart)", vim.log.levels.INFO)
    end
  end

  return new_state
end

return M
