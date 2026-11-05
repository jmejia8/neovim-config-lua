-- Fatou: Julia language server (https://fatou.dev/guide/editors.html#neovim)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config("fatou", {
  cmd = { "fatou", "lsp" },
  filetypes = { "julia" },
  root_markers = { "Project.toml", "JuliaProject.toml", ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("fatou")

-- Format on save through fatou only (respects fatou.toml)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.jl",
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf, name = "fatou" })
  end,
})
