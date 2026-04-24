local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local cmd_resolver = require("null-ls.helpers.command_resolver")

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover

local function read_package_json(root)
  local path = root .. "/package.json"
  local ok, content = pcall(vim.fn.readfile, path)
  if not ok or not content then
    return nil
  end

  local json_str = table.concat(content, "\n")
  local parse_ok, parsed = pcall(vim.fn.json_decode, json_str)
  if not parse_ok or not parsed then
    return nil
  end

  return parsed
end

local function get_oxfmt_version(package_json)
  for _, field in ipairs({ "dependencies", "devDependencies", "optionalDependencies", "peerDependencies" }) do
    local deps = package_json[field] or {}
    if deps["oxfmt"] ~= nil then
      return deps["oxfmt"]
    end
  end

  return nil
end

local function has_oxfmt_package(utils)
  if not utils.root_has_file("package.json") then
    return false
  end

  local root = vim.fn.getcwd()
  local package_json = read_package_json(root)

  return package_json ~= nil and get_oxfmt_version(package_json) ~= nil
end

local local_oxfmt_resolver = cmd_resolver.generic(vim.fs.joinpath("node_modules", ".bin"))

local function resolve_oxfmt_command(params, done)
  local_oxfmt_resolver(params, function(resolved)
    if resolved then
      done(resolved)
      return
    end

    if vim.fn.executable("oxfmt") == 1 then
      done("oxfmt")
      return
    end

    local root = params.root or vim.fn.getcwd()
    local package_json = read_package_json(root)
    local is_bun_project = package_json
      and type(package_json.packageManager) == "string"
      and package_json.packageManager:match("^bun@")

    if not is_bun_project or vim.fn.executable("bun") ~= 1 then
      done(nil)
      return
    end

    local version = get_oxfmt_version(package_json)
    local is_registry_version = type(version) == "string"
      and version ~= ""
      and not version:match("^workspace:")
      and not version:match("^file:")
      and not version:match("^link:")
    local spec = is_registry_version and ("oxfmt@" .. version) or "oxfmt"

    done({ "bun", "x", "--bun", spec })
  end)
end

-- Custom oxfmt formatter using CLI (since LSP formatting is broken)
local oxfmt = helpers.make_builtin({
  name = "oxfmt",
  method = null_ls.methods.FORMATTING,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  condition = has_oxfmt_package,
  generator_opts = {
    command = "oxfmt",
    dynamic_command = resolve_oxfmt_command,
    args = { "--stdin-filepath", "$FILENAME" },
    to_stdin = true,
  },
  factory = helpers.formatter_factory,
})

null_ls.setup({
  sources = {
    code_actions.refactoring,

    completion.spell,
    completion.tags,

    formatting.prettierd.with({
      -- Disable prettierd for filetypes where oxfmt might be used
      -- oxfmt will take precedence via condition check
      condition = function(utils)
        return not has_oxfmt_package(utils)
      end,
    }),
    formatting.shfmt,
    formatting.stylua,
    formatting.swift_format,
    oxfmt,

    hover.dictionary,
    hover.printenv,
  },
})

local ensure_installed = require("plugins.list").null_ls_sources

require("mason-null-ls").setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})
