return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TODO: need to conditionally load this depending on the project
        -- denols = {},
        eslint = {},
        tsserver = {
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },
}
