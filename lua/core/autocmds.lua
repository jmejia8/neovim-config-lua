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

-- Snacks explorer: untracked files/dirs in alarm color, ignored ones stay dim
local function snacks_git_hl()
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "DiagnosticError" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { link = "NonText" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = snacks_git_hl,
})
snacks_git_hl()
