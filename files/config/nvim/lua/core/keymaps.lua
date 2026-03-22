-- Map leader to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navigate wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Move to window using the <C-hjkl> keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch to right window" })

-- Faster
vim.keymap.set("n", "<leader>c", "<cmd>bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit current window" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Package management
vim.keymap.set("n", "<leader>pp", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>pI", "<cmd>Lazy install<CR>", { desc = "Install plugins" })
vim.keymap.set("n", "<leader>pS", "<cmd>Lazy sync<CR>", { desc = "Sync plugins" })
vim.keymap.set("n", "<leader>pU", "<cmd>Lazy update<CR>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>pX", "<cmd>Lazy clean<CR>", { desc = "Clean plugins" })

-- Terminal mode exit
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Resize window using <C-Arrow> keys
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- AI/Copilot toggle
vim.keymap.set("n", "<leader>as", function()
  local persistence = require("lib.persistence")
  persistence.toggle_supermaven()
end, { desc = "Toggle Supermaven" })
