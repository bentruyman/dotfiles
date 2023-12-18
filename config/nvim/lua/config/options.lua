local o = vim.opt

o.title = true

o.completeopt:append("noinsert")

o.fillchars:append({ fold = " ", foldclose = "▶", foldopen = "" })
o.iskeyword:append("-")
o.listchars:append({
  extends = "▶",
  nbsp = "∙",
  precedes = "◀",
  space = "·",
  tab = "▎ ",
  trail = "∙",
})

o.breakindent = true
o.breakindentopt = "sbr"
o.copyindent = true
o.showbreak = "❯ "
o.smartindent = false

o.spell = true
o.spelloptions:append("camel")

o.wrap = true

vim.cmd([[match ErrorMsg '\s\+$']])
