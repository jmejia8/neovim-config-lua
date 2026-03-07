-- Julia highlight links (applied after every colorscheme load)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "juliaFunctionCall", { link = "Identifier" })
    vim.api.nvim_set_hl(0, "juliaOperator", { link = "Keyword" })
  end,
})

-- Apply immediately for the current session (colorscheme already loaded)
vim.api.nvim_set_hl(0, "juliaFunctionCall", { link = "Identifier" })
vim.api.nvim_set_hl(0, "juliaOperator", { link = "Keyword" })
