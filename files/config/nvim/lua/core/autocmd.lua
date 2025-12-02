local util = require("lib.util")

local function augroup(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

local function format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local has_formatter = vim.lsp.get_clients({
    bufnr = bufnr,
    method = "textDocument/formatting",
  })[1] ~= nil

  if has_formatter then
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "null-ls" or client.supports_method(client, "textDocument/formatting", bufnr)
      end,
    })
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format buffer on save",
  group = augroup("format_on_save"),
  pattern = "*",
  callback = function(params)
    format_buffer(params.buf)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "CD to project root",
  group = augroup("auto_root"),
  callback = function()
    local root = util.root_dir()
    if root and vim.fn.getcwd() ~= root then
      vim.cmd("silent lcd " .. root)
    end
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight_yanked_text"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Open file in last location",
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = augroup("lsp_attach"),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    map("<leader>la", vim.lsp.buf.code_action, "Language Action", { "n", "x" })
    map("<leader>lr", vim.lsp.buf.rename, "Rename")
    map("<leader>lf", function()
      format_buffer(event.buf)
    end, "Format Buffer")
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Reload file if it's changed externally",
  group = augroup("reload_file"),
  command = "checktime",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  desc = "Resize splits when resizing window",
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Toggle relative numbering based on focus
local excluded_buftypes = util.to_set({ "help", "quickfix", "nofile" })
local excluded_filetypes = util.to_set({ "dashboard", "undotree" })

local function maybe_set_relnum(on)
  if excluded_buftypes[vim.bo.buftype] or excluded_filetypes[vim.bo.filetype] then
    vim.wo.relativenumber = false
  else
    vim.wo.relativenumber = on
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
  group = augroup("relativenumber_on_enter"),
  callback = function()
    maybe_set_relnum(true)
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "FocusLost" }, {
  group = augroup("relativenumber_on_leave"),
  callback = function()
    maybe_set_relnum(false)
  end,
})
