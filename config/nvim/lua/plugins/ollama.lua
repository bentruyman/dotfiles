return {
  {
    "nomnivore/ollama.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    keys = {
      {
        "<leader>aoo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "Prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>aog",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "Generate Code",
        mode = { "n", "v" },
      },
    },
    opts = { model = "dolphin-mixtral" },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>ao", group = "ollama", icon = "🦙" })
    end,
  },
}
