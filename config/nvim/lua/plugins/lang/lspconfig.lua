local capabilities = require("blink.cmp").get_lsp_capabilities()

local plugin_list = require("plugins.list")
local lsp_servers = plugin_list.lsp_servers
local mason_lsp_servers = plugin_list.mason_lsp_servers

local default_setup = function(server_name)
  vim.notify("Setting up " .. server_name)
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

local setup_sourcekit = function()
  if lsp_servers["sourcekit"] then
    default_setup("sourcekit")
  end
end

require("mason-lspconfig").setup({
  automatic_enable = true,
  ensure_installed = mason_lsp_servers,
  handlers = { default_setup },
})

-- Set up system-installed LSP servers that aren't available through Mason
for server_name, _ in pairs(lsp_servers) do
  if not mason_lsp_servers[server_name] then
    default_setup(server_name)
    vim.lsp.enable(server_name)
  end
end

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
            return format_client.name == "null-ls"
          end,
          bufnr = event.buf,
        })
      end

      map("<leader>lf", format, "Format")
    end
  end,
})
