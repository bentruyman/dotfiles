local M = {}

M.is_remote_host = function(host)
  local remote_url = vim.fn.system("git config --get remote.origin.url")
  return string.find(remote_url, host) ~= nil
end

M.tbl_indexof = function(tbl, val)
  for index, value in ipairs(tbl) do
    if value == val then
      return index
    end
  end
  return -1
end

M.tbl_remove = function(tbl, key)
  local index = M.tbl_indexof(tbl, key)
  if index > -1 then
    table.remove(tbl, index)
  end
end

return M
