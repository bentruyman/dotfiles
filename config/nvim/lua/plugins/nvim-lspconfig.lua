return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {},
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
