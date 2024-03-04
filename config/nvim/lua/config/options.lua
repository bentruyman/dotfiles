-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync clipboard between OS and Neovim
vim.o.clipboard = "unnamedplus"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone"

-- Highlight current line
vim.wo.cursorline = true

-- Set highlight on search
vim.o.hlsearch = false

-- Use spaces for indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Always enable line numbers
vim.wo.number = true

-- Relative line numbers
vim.wo.relativenumber = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
--
-- Enable auto-indentation
vim.o.smartindent = true
vim.o.autoindent = true

-- Enable better quality colors
vim.o.termguicolors = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Save undo history
vim.o.undofile = true
