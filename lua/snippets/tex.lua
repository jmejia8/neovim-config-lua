local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local snippets = {
  s("frame", fmta("\\begin{frame}{<>}\n    <>\n\\end{frame}", { i(1), i(2) })),
}

local autosnippets = {}

return snippets, autosnippets
