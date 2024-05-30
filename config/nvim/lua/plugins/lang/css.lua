return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TODO: disabling for now to avoid the "No Information Available"
        -- message on hover
        tailwindcss = {
          filetypes_exclude = { "markdown" },
        },
      },
    },
  },
}
