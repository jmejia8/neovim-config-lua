## Neovim Configuration (lazy.nvim)

Personal Neovim setup built on `lazy.nvim`. It focuses on fast startup, modular Lua modules, and sane defaults for development work.

### Layout

```
~/.config/nvim/
├── init.lua          -- entry point bootstrapping lazy.nvim
├── lua/
│   ├── core/         -- plugin manager and core options
│   └── keymaps.lua   -- global key mappings
└── lazy-lock.json    -- pinned plugin versions for reproducible syncs
```

### Highlights

- Colorscheme: `gruvbox.nvim` (dark background).
- UI: `dashboard-nvim`, `nvim-tree`, and devicons for quick project browsing.
- Git: `gitsigns.nvim` for inline diff hunks.
- LaTeX: `vimtex` configured to compile via `latexmk` into a `build/` directory with BibTeX support.

### Usage

```bash
# Install plugins
nvim +Lazy! sync +qa

# Compile the current TeX buffer (inside Neovim)
:VimtexCompile  # default mapping: \ll
```

### Syncing Changes

```bash
git status
git add <paths>
git commit -m "Your message"
git push
```

Clone the repo into `~/.config/nvim` to reuse the configuration.
