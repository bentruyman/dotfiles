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
      { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      opts.servers = opts.servers or {}

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      local ensure_installed = {} ---@type string[]

      for server_name, server_opts in pairs(opts.servers) do
        lspconfig[server_name].setup(vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, server_opts))

        if vim.tbl_contains(all_mslp_servers, server_name) then
          ensure_installed[#ensure_installed + 1] = server_name
        end
      end

      mason_lspconfig.setup({ ensure_installed = ensure_installed })
    end,
  },
}
