local set_keymap = vim.api.nvim_set_keymap

set_keymap("n", "<Leader>w", ":w<CR>", { noremap = true, silent = true })
