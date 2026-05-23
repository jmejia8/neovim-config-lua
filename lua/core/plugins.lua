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
      opts = function()
        local utils = require("dashboard.utils")

        if not utils._dashboard_recent_dirs then
          utils._dashboard_recent_dirs = true
          utils.get_mru_list = function()
            local seen = {}
            local dirs = {}
            for _, file in ipairs(vim.v.oldfiles or {}) do
              if type(file) == "string" and file ~= "" then
                local dir = vim.fn.fnamemodify(file, ":p:h")
                if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
                  dir = vim.fs.normalize(dir)
                  if not seen[dir] then
                    seen[dir] = true
                    table.insert(dirs, dir)
                  end
                end
              end
            end
            return dirs
          end
        end

        local function telescope_builtin(name)
          local ok, builtin = pcall(require, "telescope.builtin")
          if not ok then
            return nil
          end
          return builtin[name]
        end

        local function telescope_git_or_files()
          local git_files = telescope_builtin("git_files")
          if git_files then
            local ok = pcall(git_files, { show_untracked = true })
            if ok then
              return
            end
          end
          local find_files = telescope_builtin("find_files")
          if find_files then
            find_files()
          end
        end

        return {
          theme = "hyper",
          config = {
            header = {
              " ███╗   ██╗ ███████╗██╗   ██╗██╗███╗   ███╗",
              " ████╗  ██║ ██╔════╝██║   ██║██║████╗ ████║",
              " ██╔██╗ ██║ █████╗  ██║   ██║██║██╔████╔██║",
              " ██║╚██╗██║ ██╔══╝  ██║   ██║██║██║╚██╔╝██║",
              " ██║ ╚████║ ███████╗╚██████╔╝██║██║ ╚═╝ ██║",
              " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝  ╚═╝╚═╝     ╚═╝",
            },
            week_header = {
              enable = true,
              concat = "  ",
              append = { "Time to develop." },
            },
            shortcut = {
              {
                icon = " ",
                icon_hl = "Title",
                desc = "Projects",
                group = "String",
                action = telescope_git_or_files,
                key = "p",
                key_hl = "Number",
              },
              {
                icon = "󱂬 ",
                icon_hl = "Operator",
                desc = "Recent Dirs",
                group = "String",
                action = function()
                  local find_files = telescope_builtin("find_files")
                  if not find_files then
                    return
                  end
                  local dirs = utils.get_mru_list()
                  if not dirs or #dirs == 0 then
                    find_files()
                    return
                  end
                  find_files({ cwd = dirs[1] })
                end,
                key = "r",
                key_hl = "Number",
              },
              {
                icon = " ",
                icon_hl = "String",
                desc = "Edit Config",
                group = "String",
                action = function()
                  local find_files = telescope_builtin("find_files")
                  if find_files then
                    find_files({ cwd = vim.fn.stdpath("config") })
                  end
                end,
                key = "c",
                key_hl = "Number",
              },
            },
            packages = { enable = true },
            project = {
              enable = true,
              limit = 6,
              icon = " ",
              label = "Projects",
              action = function(path)
                local find_files = telescope_builtin("find_files")
                if find_files then
                  find_files({ cwd = path })
                end
              end,
            },
            mru = {
              enable = true,
              limit = 8,
              icon = " ",
              label = " Recent Directories:",
              cwd_only = false,
            },
            footer = {
              "nvim · gruvbox · dashboard-nvim",
              "https://github.com/nvimdev/dashboard-nvim",
            },
          },
        }
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {},
    },
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      version = false,
      dependencies = { "nvim-lua/plenary.nvim" },
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
          out_dir = "build",
          continuous = 1,
          callback = 1,
          options = {
            "-verbose",
            "-interaction=nonstopmode",
            '-file-line-error',
            "-synctex=0",
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
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        local luasnip = require("luasnip")
        luasnip.config.set_config({
          enable_autosnippets = false,
          store_selection_keys = "<Tab>",
        })
        -- Load VSCode-style snippets from friendly-snippets and any other plugins
        require("luasnip.loaders.from_vscode").lazy_load()
        -- Ensure tex snippets are also available in plaintex/latex filetypes
        require("luasnip.loaders.from_vscode").lazy_load({
          include = { "tex", "latex", "plaintex" },
        })
        require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })

        -- Treat plaintex and latex like tex so vscode tex snippets apply.
        luasnip.filetype_extend("plaintex", { "tex" })
        luasnip.filetype_extend("latex", { "tex" })
      end,
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
      opts = function()
        local files_cmd = "find"
        if vim.fn.executable("fd") == 1 then
          files_cmd = "fd"
        elseif vim.fn.executable("fdfind") == 1 then
          files_cmd = "fdfind"
        end

        return {
          explorer = { enabled = true },
          picker = {
            enabled = true,
            sources = {
              files = { cmd = files_cmd },
            },
          },
          image = { enabled = true },
        }
      end,
      init = function()
        vim.env.SNACKS_GHOSTTY = vim.env.SNACKS_GHOSTTY or "true"
      end,
    },
  },
})
