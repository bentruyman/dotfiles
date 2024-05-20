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
    },
    keys = {
      { "<leader>L", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()
      mason_lspconfig.setup()

      require("neodev").setup()

      opts.servers = opts.servers or {}
      opts.extra_servers = opts.extra_servers or {}

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local server_names = vim.tbl_keys(opts.servers)

      local function setup_lsp(server_name, server_opts)
        lspconfig[server_name].setup(vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, server_opts))
      end

      mason_lspconfig.setup({ ensure_installed = server_names })
      mason_lspconfig.setup_handlers({
        function(server_name)
          setup_lsp(server_name, opts.servers[server_name])
        end,
      })

      for server_name, server_opts in pairs(opts.extra_servers) do
        setup_lsp(server_name, server_opts)
      end
    end,
  },
}
