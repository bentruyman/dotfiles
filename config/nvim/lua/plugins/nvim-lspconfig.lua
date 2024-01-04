return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        marksman = {},
        tsserver = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
      },
    },
  },
}
