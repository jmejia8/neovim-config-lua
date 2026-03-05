local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      lazy = false,
      opts = {},
      config = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("gruvbox")
      end,
    },
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end,
      opts = {
        sync_root_with_cwd = true,
        view = {
          width = 34,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {},
    },
    {
      "lervag/vimtex",
      ft = { "tex", "plaintex", "latex" },
      init = function()
        vim.g.tex_flavor = "latex"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
          build_dir = "build",
          aux_dir = "build",
          options = {
            "-pdf",
            "-interaction=nonstopmode",
            "-synctex=1",
          },
        }
      end,
    },
    {
      "JuliaEditorSupport/julia-vim",
      lazy = false,
    },
    {
      "nickjvandyke/opencode.nvim",
      version = "*",
      dependencies = {
        {
          "folke/snacks.nvim",
          optional = true,
        },
      },
      config = function()
        vim.g.opencode_opts = vim.g.opencode_opts or {}
        vim.o.autoread = true

        local opencode = require("opencode")
        local map = vim.keymap.set

        map({ "n", "x" }, "<leader>oa", function()
          opencode.ask("@this: ", { submit = true })
        end, { desc = "Ask opencode" })

        map({ "n", "x" }, "<leader>os", function()
          opencode.select()
        end, { desc = "Open opencode actions" })

        map({ "n", "t" }, "<leader>ot", function()
          opencode.toggle()
        end, { desc = "Toggle opencode" })

        map("n", "<leader>ou", function()
          opencode.command("session.half.page.up")
        end, { desc = "Scroll opencode up" })

        map("n", "<leader>od", function()
          opencode.command("session.half.page.down")
        end, { desc = "Scroll opencode down" })
      end,
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        image = {
          enabled = true,
        },
      },
      init = function()
        vim.env.SNACKS_GHOSTTY = vim.env.SNACKS_GHOSTTY or "true"
      end,
    },
  },
})
