vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<C-n>", function()
  require("snacks.explorer")()
end, { desc = "Toggle file explorer" })

vim.keymap.set("n", "<leader>sf", function()
  require("snacks.picker").files()
end, { desc = "Snacks find files" })

-- Project-wide search (ripgrep over cwd, respects .gitignore)
vim.keymap.set("n", "<C-S-f>", function()
  require("snacks.picker").grep()
end, { desc = "Grep project" })

-- Search the word under cursor (or visual selection) across the project
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
  require("snacks.picker").grep_word()
end, { desc = "Grep word/selection in project" })
