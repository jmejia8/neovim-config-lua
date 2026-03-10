local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local snippets = {
  s("fn", fmta("function <>()<>\nend", { i(1, "name"), i(2) })),
  s("map", fmta("map(<>) do <>\n    <>\nend", { i(1, "x"), i(2, "x"), i(3) })),
  s("filter", fmta("filter(<>) do <>\n    <>\nend", { i(1, "x"), i(2, "x"), i(3) })),
  s("reduce", fmta("reduce(<>, <>) do <>\n    <>\nend", { i(1, "acc"), i(2, "x"), i(3, "acc"), i(4) })),
  s("for", fmta("for <> in <>\n    <>\nend", { i(1, "i"), i(2, "1:n"), i(3) })),
  s("while", fmta("while <> \n    <>\nend", { i(1, "true"), i(2) })),
  s("if", fmta("if <> \n    <>\nend", { i(1, "condition"), i(2) })),
  s("ife", fmta("if <> \n    <>\nelse\n    <>\nend", { i(1, "condition"), i(2), i(3) })),
  s("let", fmta("let <> = <>\n    <>\nend", { i(1, "x"), i(2, "value"), i(3) })),
  s("struct", fmta("struct <> \n    <>\nend", { i(1, "Name"), i(2) })),
  s("mutable", fmta("mutable struct <> \n    <>\nend", { i(1, "Name"), i(2) })),
  s("begin", fmta("begin \n    <>\nend", { i(1) })),
  s("try", fmta("try \n    <>\ncatch <>\n    <>\nend", { i(1), i(2, "e"), i(3) })),
  s("module", fmta("module <> \n    \nend", { i(1, "ModuleName") })),
  s("using", fmta("using <>", { i(1, "Pkg") })),
  s("import", fmta("import <>", { i(1, "Pkg") })),
  s("export", fmta("export <>", { i(1, "name") })),
  s("doc", fmta('"""<> \n<> \n"""', { i(1, "Description"), i(2) })),
  s("macro", fmta("macro <>(<>)\n    <>\nend", { i(1, "name"), i(2), i(3) })),
  s("typeassert", fmta("<>::<>", { i(1, "var"), i(2, "Type") })),
  s("abstract", fmta("abstract type <> end", { i(1, "AbstractName") })),
  s("primtype", fmta("primitive type <> <> end", { i(1, "Name"), i(2, "8") })),
  s("do", fmta("do <>\n    <>\nend", { i(1, "arg"), i(2) })),
  s("@.", fmta("@. <>", { i(1, "expr") })),
  s("@inline", fmta("@inline <>", { i(1) })),
  s("@inbounds", fmta("@inbounds <>", { i(1) })),
  s("@fastmath", fmta("@fastmath <>", { i(1) })),
  s("@test", fmta("@test <>", { i(1, "expr") })),
  s("@benchmark", fmta("@benchmark <>", { i(1, "expr") })),
  s("isa", fmta("isa(<>)", { i(1, "var") })),
  s("println", fmta("println(<>)", { i(1, "\"hello\"") })),
  s("print", fmta("print(<>)", { i(1, "\"hello\"") })),
  s("return", fmta("return <>", { i(1) })),
  s("break", t("break")),
  s("continue", t("continue")),
  s("nothing", t("nothing")),
  s("true", t("true")),
  s("false", t("false")),
}

local autosnippets = {}

return snippets, autosnippets
