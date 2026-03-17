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
      "hrsh7th/nvim-cmp",
      version = "*",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        local function try_latex_to_unicode()
          if vim.bo.filetype ~= "julia" then
            return false
          end
          if vim.fn.exists("*LaTeXtoUnicode#Tab") == 0 then
            return false
          end

          local cursor = vim.api.nvim_win_get_cursor(0)
          local col = cursor[2]
          local line = vim.api.nvim_get_current_line()
          local prefix = line:sub(1, col)

          if not prefix:match("\\[^%s\\]+$") then
            return false
          end

          vim.fn["LaTeXtoUnicode#Tab"]()
          return true
        end

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
          completion = {
            autocomplete = false,
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif try_latex_to_unicode() then
                return
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            {
              name = "nvim_lsp",
              entry_filter = function(entry, _ctx)
                return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
              end,
            },
          }, {
            { name = "buffer" },
          }),
        })

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        })

        cmp.setup.cmdline("/", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        })
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      config = function()
        local luasnip = require("luasnip")
        luasnip.config.set_config({
          enable_autosnippets = false,
          store_selection_keys = "<Tab>",
        })
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
      end,
    },
    {
      "rafamadriz/friendly-snippets",
    },
    {
      "JuliaEditorSupport/julia-vim",
      lazy = false,
      init = function()
        vim.g.latex_to_unicode_tab = "on"
        vim.g.latex_to_unicode_suggestions = 1
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        map_bs = true,
        map_cr = true,
        enable_check_bracket_line = true,
      },
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
