return {
  {
    "nomnivore/ollama.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    keys = {
      {
        "<leader>oo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "Prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>oG",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "Generate Code",
        mode = { "n", "v" },
      },
    },
    opts = { model = "dolphin-mixtral" },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>o"] = { name = "+ollama" },
      },
    },
  },
}
