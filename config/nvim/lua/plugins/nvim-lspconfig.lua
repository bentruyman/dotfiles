local utils = require("utils")

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- Code
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")

  -- Files
  vim.keymap.set("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all" })
  vim.keymap.set("n", "<leader>wq", "<cmd>wqa<cr>", { desc = "Save & quit" })
  vim.keymap.set("n", "<leader>ww", ":w<CR>", { desc = "Save file" })
  vim.keymap.set("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Quit and discard changes" })

  -- LSP
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")

  -- Telescope
  nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
  nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
  nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")

  vim.api.nvim_buf_create_user_command(_, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "b0o/schemastore.nvim",
    },
    keys = {
      { "<leader>L", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()
      mason_lspconfig.setup()

      require("neodev").setup()

      local servers = {
        biome = {},
        denols = {
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        },
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {},
        -- TODO: figure out why this isn't working with mason-lspconfig
        gdscript = {},
        gopls = {},
        html = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas({
                extra = {
                  -- TODO: deno.json isn't working
                  {
                    name = "deno.json",
                    description = "Deno Configuration File",
                    fileMatch = "deno.json",
                    url = "https://raw.githubusercontent.com/denoland/deno/main/cli/schemas/config-file.v1.json",
                  },
                },
              }),
              validate = { enable = true },
            },
          },
        },
        lua_ls = {},
        marksman = {},
        rust_analyzer = {},
        tsserver = {
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            on_attach(client, bufnr)
          end,
          root_dir = lspconfig.util.root_pattern("package.json"),
          single_file_support = false,
        },
        yamlls = {},
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local server_names = vim.tbl_keys(servers)
      utils.tbl_remove(server_names, "gdscript")

      mason_lspconfig.setup({ ensure_installed = server_names })
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup(vim.tbl_extend("force", {
            capabilities = capabilities,
            on_attach = on_attach,
          }, servers[server_name]))
        end,
      })
    end,
  },
}
