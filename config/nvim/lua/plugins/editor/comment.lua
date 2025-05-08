local Comment = require("Comment")
local comment_api = require("Comment.api")

Comment.setup()

vim.keymap.set("n", "<leader>/", function()
  return comment_api.call("toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"), "g@$")()
end, {
  expr = true,
  noremap = true,
  silent = true,
  desc = "Toggle comment line(s)",
})

vim.keymap.set(
  "v",
  "<leader>/",
  "<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>",
  {
    noremap = true,
    silent = true,
    desc = "Toggle comment selection (linewise)",
  }
)
