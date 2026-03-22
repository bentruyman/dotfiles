local M = {}

local bun_adapter = require("neotest-bun")
local uv = vim.uv or vim.loop

local source_extensions = { "ts", "tsx", "js", "jsx" }
local test_suffixes = { "test", "spec" }

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.WARN, { title = "Test Navigation" })
end

local function normalize(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function file_exists(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file"
end

local function join_path(...)
  return normalize(vim.fs.joinpath(...))
end

local function split_filename(path)
  local filename = vim.fs.basename(path)
  local stem, extension = filename:match("^(.*)%.([^.]+)$")

  return stem, extension
end

local function extension_priority(current_extension)
  local ordered = {}
  local seen = {}

  local function add(extension)
    if not extension or seen[extension] then
      return
    end

    seen[extension] = true
    table.insert(ordered, extension)
  end

  for _, extension in ipairs(source_extensions) do
    if extension == current_extension then
      add(extension)
      break
    end
  end

  for _, extension in ipairs(source_extensions) do
    add(extension)
  end

  return ordered
end

local function add_test_candidates(candidates, directory, stem, extensions)
  for _, extension in ipairs(extensions) do
    for _, suffix in ipairs(test_suffixes) do
      table.insert(candidates, directory .. "/" .. stem .. "." .. suffix .. "." .. extension)
    end
  end
end

local function add_source_candidates(candidates, directory, stem, extensions)
  for _, extension in ipairs(extensions) do
    table.insert(candidates, directory .. "/" .. stem .. "." .. extension)
  end
end

local function strip_test_suffix(stem)
  return stem:match("^(.*)%.test$") or stem:match("^(.*)%.spec$")
end

local function relative_to_root(path, root, directory_name)
  if not root then
    return nil
  end

  local prefix = normalize(root .. "/" .. directory_name .. "/")
  if not vim.startswith(path, prefix) then
    return nil
  end

  return path:sub(#prefix + 1)
end

local function unique_candidates(candidates)
  local deduped = {}
  local seen = {}

  for _, candidate in ipairs(candidates) do
    candidate = normalize(candidate)
    if candidate and not seen[candidate] then
      seen[candidate] = true
      table.insert(deduped, candidate)
    end
  end

  return deduped
end

local function related_source_candidates(path, root, extensions)
  local candidates = {}
  local directory = vim.fs.dirname(path)
  local stem = split_filename(path)
  local source_stem = stem and strip_test_suffix(stem)

  if not source_stem then
    return candidates
  end

  add_source_candidates(candidates, directory, source_stem, extensions)

  local relative_path = relative_to_root(path, root, "test")
  if not relative_path then
    return candidates
  end

  local relative_stem = split_filename(relative_path)
  local mirrored_stem = relative_stem and strip_test_suffix(relative_stem)
  if not mirrored_stem then
    return candidates
  end

  local source_directory = join_path(root, "src")
  local relative_directory = vim.fs.dirname(relative_path)
  if relative_directory ~= "." then
    source_directory = join_path(source_directory, relative_directory)
  end

  add_source_candidates(candidates, source_directory, mirrored_stem, extensions)

  return candidates
end

local function related_test_candidates(path, root, extensions)
  local candidates = {}
  local directory = vim.fs.dirname(path)
  local stem = split_filename(path)

  if not stem then
    return candidates
  end

  add_test_candidates(candidates, directory, stem, extensions)

  local relative_path = relative_to_root(path, root, "src")
  if not relative_path then
    return candidates
  end

  local relative_stem = split_filename(relative_path)
  if not relative_stem then
    return candidates
  end

  local test_directory = join_path(root, "test")
  local relative_directory = vim.fs.dirname(relative_path)
  if relative_directory ~= "." then
    test_directory = join_path(test_directory, relative_directory)
  end

  add_test_candidates(candidates, test_directory, relative_stem, extensions)

  return candidates
end

function M.find_related(path)
  path = normalize(path)
  if not path then
    return nil
  end

  local stem, extension = split_filename(path)
  if not stem or not extension then
    return nil
  end

  local root = bun_adapter.root(vim.fs.dirname(path))
  local extensions = extension_priority(extension)
  local candidates = bun_adapter.is_test_file(path)
      and related_source_candidates(path, root, extensions)
    or related_test_candidates(path, root, extensions)

  for _, candidate in ipairs(unique_candidates(candidates)) do
    if file_exists(candidate) then
      return candidate
    end
  end
end

function M.open_related(opts)
  opts = opts or {}

  local path = normalize(vim.api.nvim_buf_get_name(0))
  if not path then
    notify("Current buffer is not backed by a file")
    return
  end

  local target = M.find_related(path)
  if not target then
    notify("No related test or source file found for " .. vim.fs.basename(path))
    return
  end

  vim.cmd(opts.open_cmd or "vsplit")
  vim.cmd("edit " .. vim.fn.fnameescape(target))
end

return M
