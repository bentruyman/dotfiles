local capabilities = require("blink.cmp").get_lsp_capabilities()

local plugin_list = require("plugins.list")
local lsp_servers = plugin_list.lsp_servers
local mason_lsp_servers = plugin_list.mason_lsp_servers
local mason_lspconfig = require("mason-lspconfig")
local mason_registry = require("mason-registry")

local pending_mason_installs = {}

local default_setup = function(server_name)
  -- vim.notify("Setting up " .. server_name)
  local server_config = lsp_servers[server_name]
  local config = {}

  if type(server_config) == "function" then
    config = server_config()
  elseif type(server_config) == "table" then
    config = server_config
  elseif server_config == true then
    config = {}
  else
    config = {}
  end

  config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})

  vim.lsp.config(server_name, config)
end

require("mason-lspconfig").setup({
  automatic_enable = true,
  ensure_installed = {},
  handlers = { default_setup },
})

local function install_mason_lsp_for_filetype(filetype)
  if not filetype or filetype == "" then
    return
  end

  mason_registry.refresh(vim.schedule_wrap(function(success)
    if not success then
      return
    end

    local mappings = mason_lspconfig.get_mappings()
    local available_servers = mason_lspconfig.get_available_servers({ filetype = filetype })

    for _, server_name in ipairs(available_servers) do
      if mason_lsp_servers[server_name] and not pending_mason_installs[server_name] then
        local package_name = mappings.lspconfig_to_package[server_name]
        if package_name and not mason_registry.is_installed(package_name) then
          local ok, pkg = pcall(mason_registry.get_package, package_name)
          if ok then
            pending_mason_installs[server_name] = true
            pkg:install({}, function()
              pending_mason_installs[server_name] = nil
            end)
          end
        end
      end
    end
  end))
end

-- Set up system-installed LSP servers that aren't available through Mason
for server_name, _ in pairs(lsp_servers) do
  if not mason_lsp_servers[server_name] then
    default_setup(server_name)
    vim.lsp.enable(server_name)
  end
end

-- Manually start system LSP servers for existing buffers (handles lazy loading race condition)
vim.schedule(function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
      local ft = vim.bo[bufnr].filetype
      if ft == "" then
        goto continue
      end
      install_mason_lsp_for_filetype(ft)
      for server_name, _ in pairs(lsp_servers) do
        if not mason_lsp_servers[server_name] then
          local config = vim.lsp.config[server_name]
          if config and vim.tbl_contains(config.filetypes or {}, ft) then
            local root = config.root_dir and config.root_dir(bufnr) or nil
            if root then
              vim.lsp.start(vim.tbl_extend("force", config, { root_dir = root }), { bufnr = bufnr })
            end
          end
        end
      end
      ::continue::
    end
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("mason-lsp-auto-install", { clear = true }),
  callback = function(event)
    install_mason_lsp_for_filetype(vim.bo[event.buf].filetype)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    map("<leader>la", vim.lsp.buf.code_action, "Language Action", { "n", "x" })
    map("<leader>lr", vim.lsp.buf.rename, "Rename")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentFormattingProvider then
      local format = function()
        vim.lsp.buf.format({
          filter = function(format_client)
            -- Use null-ls for formatting (oxfmt LSP formatting is broken, use null-ls oxfmt source instead)
            return format_client.name == "null-ls"
          end,
          bufnr = event.buf,
        })
      end

      map("<leader>lf", format, "Format")
    end
  end,
})
