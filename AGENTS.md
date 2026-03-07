# Neovim Configuration - Agent Guidelines

This is a Neovim configuration repository using lazy.nvim for plugin management.

## Project Overview

- **Type**: Neovim configuration (dotfiles)
- **Plugin Manager**: lazy.nvim
- **Language**: Lua 5.1 / Neovim Lua API
- **Structure**: Modular with entry point at `init.lua`

## Directory Structure

```
~/.config/nvim/
├── init.lua              -- Entry point, bootstraps lazy.nvim
├── lua/
│   ├── core/            -- Core modules
│   │   ├── plugins.lua  -- Plugin definitions and lazy.nvim setup
│   │   ├── options.lua  -- Vim options (vim.opt, vim.g)
│   │   └── autocmds.lua -- Autocommands and highlight links
│   └── keymaps.lua      -- Global key mappings
└── lazy-lock.json       -- Pinned plugin versions
```

---

## Build / Lint / Test Commands

### Plugin Installation
```bash
nvim +Lazy! sync +qa    # Install all plugins
```

### Vimtex (LaTeX) Compilation
```bash
:VimtexCompile          # Default mapping: \ll
```

### Health Check
```bash
:checkhealth           -- Neovim diagnostics
:Lazy profile          -- Plugin startup timing
:Lazy health           -- lazy.nvim health
```

### Reload Configuration
```bash
:source $MYVIMRC       -- Reload init.lua
:luafile %             -- Reload current Lua file
```

### No Formal Linting/Testing
This is a configuration repo without automated tests. Manual verification is used.

---

## Code Style Guidelines

### File Organization

- Entry point: `init.lua` (minimal, just requires modules)
- Core modules in `lua/core/`
- Each module in separate file: `plugins.lua`, `options.lua`, `autocmds.lua`
- Additional modules as needed under `lua/`

### Lua Conventions

**Vim Options & Global Variables**
```lua
vim.opt.number = true          -- boolean
vim.opt.tabstop = 4            -- number
vim.opt.spelllang = { "en_us" } -- list
vim.g.mapleader = " "          -- for keymaps
vim.g.julia_highlight_operators = 1  -- plugin settings
```

**Plugin Specifications (in plugins.lua)**
```lua
{
  "author/plugin-name",    -- GitHub shorthand
  event = "BufReadPre",     -- Loading strategy
  dependencies = { "dep/name" },
  opts = {},                -- Passed to setup()
  config = function()       -- Run after plugin loads
    -- configuration
  end,
  init = function()         -- Run before plugin loads (for vim.g vars)
    vim.g.setting = true
  end,
}
```

**Loading Strategy Priority** (least expensive first):
- `lazy = true` (default - load on demand)
- `event = "..."` (on buffer/event)
- `cmd = "..."` (on command)
- `ft = "..."` (filetype)
- `lazy = false` (load at startup)

### Naming Conventions

- **Files**: snake_case.lua (e.g., `keymaps.lua`, `autocmds.lua`)
- **Variables**: snake_case (e.g., `lazypath`, `mapleader`)
- **Functions**: snake_case (e.g., `create_autocmd`)
- **Highlight groups**: camelCase or snake_case

### Keymap Definition
```lua
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set({ "n", "x" }, "<leader>f", function() end, { desc = "Description" })
```

### Autocommands
```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "julia",
  callback = function()
    -- setup for filetype
  end,
})

-- For persistent highlights (survives colorscheme changes)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "GroupName", { link = "Identifier" })
  end,
})
```

### Highlight Links
```lua
-- Set immediately (current session)
vim.api.nvim_set_hl(0, "juliaFunctionCall", { link = "Identifier" })

-- Wrap in ColorScheme autocmd for persistence
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "juliaFunctionCall", { link = "Identifier" })
  end,
})
```

### Error Handling & Debugging

- Keep config simple - errors cause silent failures
- Use `vim.print()` for debugging (Neovim 0.10+)
- Use `:messages` to see errors
- Test changes by sourcing files: `:luafile %`

### Import Patterns
```lua
require("core.plugins")   -- loads lua/core/plugins.lua
require("keymaps")        -- loads lua/keymaps.lua
```

### Formatting

- 2-space indentation (Neovim convention)
- No trailing whitespace
- Use double quotes for strings

### Plugin Manager Bootstrap
```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob=none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ spec = { -- plugins here } })
```

---

## Notes for Agents

1. **Don't break startup**: Test any changes with `nvim --headless -c "q"`
2. **Avoid adding many plugins**: This config emphasizes minimalism
3. **Use lazy loading**: Don't use `lazy = false` unless plugin is always needed
4. **Check for conflicts**: Existing plugins (gruvbox, nvim-tree, gitsigns, vimtex, julia-vim)
5. **Respect existing patterns**: Match the style in existing files
6. **Check plugin features first**: Before creating custom syntax rules or workarounds, check what the plugin already provides (e.g., julia-vim has built-in highlight groups like `juliaFunctionCall`, `juliaOperator` that can be linked to existing highlight groups)
