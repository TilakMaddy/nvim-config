# Neovim Configuration Documentation

## Overview

This is a personalized Neovim configuration built on top of
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It uses
[lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager and is
designed around a few core principles:

- **Heavy LSP integration** -- Language Server Protocol support for 10+
  languages via Mason with auto-installation of servers, formatters, and
  linters.
- **AI-assisted coding** -- Avante.nvim provides an in-editor AI chat sidebar
  powered by Claude (via OpenRouter).
- **Polyglot language support** -- First-class configurations for Lua, Go,
  Python, TypeScript, JavaScript, Rust, C/C++, Elixir, PHP/Blade, Svelte,
  Gleam, Solidity, and Deno.
- **Telescope-centric workflow** -- Fuzzy finding for files, grep, symbols,
  diagnostics, buffers, and more.
- **Performance-conscious** -- Lazy-loaded plugins, disabled built-in plugins,
  disabled unused providers, and Treesitter-based highlighting.

The leader key is **Space**.

---

## Prerequisites

### Required

| Dependency        | Minimum Version | Purpose                                    |
|-------------------|-----------------|--------------------------------------------|
| **Neovim**        | 0.10+           | Editor (uses native LSP config via `vim.lsp.config`) |
| **Nerd Font**     | any             | Icons in statusline, file tree, and UI     |
| **git**           | any             | Plugin installation, Grapple git scope     |
| **make**          | any             | Building telescope-fzf-native, LuaSnip, Avante |
| **npm / Node.js** | any             | Markdown preview, some LSP servers         |
| **ripgrep** (`rg`)| any             | Telescope live grep, todo-comments         |

### Optional

| Dependency        | Purpose                                              |
|-------------------|------------------------------------------------------|
| **ImageMagick**   | SVG-to-PNG conversion for in-editor image rendering  |
| **Kitty terminal**| Kitty graphics protocol backend for image.nvim       |
| **Lazygit**       | Terminal UI for git, launched via `<leader>gg`        |
| **fd**            | Faster file finding for Telescope (auto-detected)    |

---

## Directory Structure

```
~/.config/nvim/
|-- init.lua                        Bootstrap: leader key, core modules, lazy.nvim
|-- lua/
|   |-- core/
|   |   |-- options.lua             Vim options (numbers, tabs, search, appearance)
|   |   |-- keymaps.lua             Core keybindings (escape, window nav, diagnostics)
|   |   |-- autocmds.lua            Autocommands (yank highlight, blade filetype)
|   |-- plugins/
|       |-- avante.lua              AI assistant (Avante.nvim + OpenRouter)
|       |-- colorscheme.lua         Themes: tokyonight, catppuccin, rose-pine, kanagawa, everforest
|       |-- completion.lua          Completion engine (blink.cmp + LuaSnip)
|       |-- editor.lua              which-key, autopairs, todo-comments, highlight-colors
|       |-- flash.lua               Flash.nvim jump/motion
|       |-- formatting.lua          conform.nvim (format on save)
|       |-- git.lua                 gitsigns + vim-fugitive
|       |-- image.lua               In-editor image rendering (kitty backend)
|       |-- lang-elixir.lua         Elixir language tooling (elixir-tools.nvim)
|       |-- lang-php.lua            PHP/Blade navigation (blade-nav.nvim)
|       |-- lang-rust.lua           Rust tooling (rustaceanvim)
|       |-- linting.lua             nvim-lint (ruff for Python, golangci-lint for Go)
|       |-- lsp.lua                 LSP config, Mason, mason-tool-installer
|       |-- markdown-preview.lua    Browser-based markdown preview
|       |-- mini.lua                mini.ai, mini.surround, mini.statusline
|       |-- navigation.lua          nvim-tree file explorer + Grapple file tagging
|       |-- oil.lua                 Oil.nvim (buffer-based file manager)
|       |-- snacks.lua              snacks.nvim (notifier, lazygit, terminal, bigfile)
|       |-- telescope.lua           Telescope fuzzy finder + fzf-native
|       |-- treesitter.lua          Treesitter (syntax, textobjects, indent)
|       |-- undotree.lua            Undo history visualizer
|-- after/
|   |-- lsp/
|       |-- clangd.lua              C/C++ LSP settings (UTF-16 offset encoding)
|       |-- denols.lua              Deno LSP settings
|       |-- gleam.lua               Gleam LSP settings
|       |-- gopls.lua               Go LSP settings (staticcheck, gofumpt)
|       |-- lua_ls.lua              Lua LSP settings (call snippets)
|       |-- phpactor.lua            PHP LSP settings
|       |-- pyright.lua             Python LSP settings
|       |-- solidity.lua            Solidity LSP settings
|       |-- svelte.lua              Svelte LSP settings
|       |-- ts_ls.lua               TypeScript LSP settings (root markers, no SFS)
|-- doc/
|   |-- kickstart.txt               Upstream kickstart help file
```

---

## Architecture

### Startup Sequence

1. **`init.lua`** runs first. It:
   - Sets the leader key to **Space** (`vim.g.mapleader = " "`).
   - Sets `vim.g.nerd_font = true` so plugins can use Nerd Font icons.
   - Loads the three core modules in order: `core.options`, `core.keymaps`,
     `core.autocmds`.
   - Bootstraps lazy.nvim by cloning it into `~/.local/share/nvim/lazy/` if it
     is not already present.
   - Calls `require("lazy").setup()` with `{ import = "plugins" }`, which
     tells lazy.nvim to auto-discover and load every `*.lua` file inside
     `lua/plugins/`.

2. **lazy.nvim** reads all plugin specs from `lua/plugins/`, resolves
   dependencies, installs missing plugins, and applies lazy-loading rules
   (`event`, `cmd`, `ft`, `keys`).

3. **Neovim's native LSP** (0.10+) picks up files in `after/lsp/` to
   configure individual language servers. Each file returns a table of settings
   that is automatically merged into that server's config by
   `vim.lsp.config()`.

### Key Design Decisions

- **No netrw.** The built-in file explorer is disabled in `options.lua`
  (`vim.g.loaded_netrw = 1`). nvim-tree and Oil are used instead.
- **No external providers.** Python, Ruby, Perl, and Node providers are all
  disabled for faster startup.
- **Performance tuning.** Seven built-in plugins are disabled via
  `disabled_plugins` in lazy.nvim's performance settings (gzip, matchit,
  matchparen, tarPlugin, tohtml, tutor, zipPlugin). Lazy.nvim's cache is
  enabled.
- **System clipboard.** The clipboard is set to `unnamedplus` via
  `vim.schedule()` to avoid blocking startup.
- **Persistent undo.** Swap files are disabled but undo files are enabled,
  giving persistent undo history across sessions. Undotree provides a visual
  browser for this history.
- **Persistent theme.** The selected colorscheme is saved to
  `~/.local/share/nvim/theme.txt` and restored on startup.

### Core Options Summary

| Category      | Settings                                                      |
|---------------|---------------------------------------------------------------|
| Line numbers  | Absolute + relative                                           |
| Indentation   | 4 spaces, expandtab, smart indent, break indent               |
| Search        | Incremental, case-insensitive with smart-case, no hlsearch    |
| Appearance    | No line wrap, true colors, cursorline, sign column always on   |
| Splits        | Open right and below                                          |
| Timing        | 250ms updatetime, 300ms timeoutlen                            |
| Whitespace    | Visible tabs (`>>` ), trailing spaces (`*`), nbsp             |

---

## Index of Documentation

| Document                        | Description                                     |
|---------------------------------|-------------------------------------------------|
| [keymaps.md](keymaps.md)        | Complete keybinding reference for all modes      |
| [lsp.md](lsp.md)               | LSP servers, completion, formatting, and linting |
| [plugins.md](plugins.md)        | Full plugin list with configuration details      |
| [navigation.md](navigation.md)  | File navigation, Telescope, tree, Oil, Grapple   |
| [ui.md](ui.md)                  | Themes, statusline, notifications, UI elements   |
| [languages.md](languages.md)    | Language-specific setups and per-language notes   |

---

## Quick Start

### 1. Clone the repository

```bash
git clone <your-repo-url> ~/.config/nvim
```

If you already have a Neovim config, back it up first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 2. Open Neovim

```bash
nvim
```

On first launch, lazy.nvim will automatically clone itself and install all
plugins. You will see a progress window. Wait for it to finish.

### 3. Install Treesitter parsers

Treesitter grammars are installed automatically via `ensure_installed`, but you
can trigger a manual update with:

```vim
:TSUpdate
```

### 4. Install LSP servers and tools

Mason will auto-install the tools listed in `mason-tool-installer`. To manage
them manually or install additional servers:

```vim
:Mason
```

The following are installed automatically:

**LSP servers:** lua-language-server, gopls, pyright, typescript-language-server,
deno, clangd, tailwindcss-language-server, eslint-lsp, phpactor

**Formatters:** stylua, clang-format, prettierd

**Linters:** ruff, golangci-lint

### 5. AI setup (optional)

Avante is configured to use OpenRouter with an API key read from your
`~/.zshrc`. Ensure you have the following line in your shell config:

```bash
export OPENROUTER_API_KEY="your-key-here"
```

---

## Customization

### Adding a new plugin

Create a new file in `lua/plugins/`. lazy.nvim will automatically pick it up.
The file must return a table (or a list of tables) following the lazy.nvim
plugin spec format:

```lua
-- lua/plugins/my-plugin.lua
return {
    "author/plugin-name",
    event = "VeryLazy",  -- lazy-loading trigger
    opts = {
        -- plugin options
    },
}
```

### Adding or configuring an LSP server

1. If the server is available via Mason, add it to the `ensure_installed` list
   in `lua/plugins/lsp.lua`.

2. Create a file in `after/lsp/` named after the server (e.g.,
   `after/lsp/rust_analyzer.lua`). The file should return a table of settings:

```lua
-- after/lsp/rust_analyzer.lua
return {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
}
```

Neovim 0.10+ will automatically merge these settings when the server starts.
Note that `mason-lspconfig` with `automatic_enable` handles starting servers
for you -- no explicit `lspconfig[server].setup()` call is needed.

### Adding a formatter

Add the formatter tool name to `ensure_installed` in `lua/plugins/lsp.lua`,
then add a filetype mapping in `lua/plugins/formatting.lua`:

```lua
formatters_by_ft = {
    -- existing entries...
    ruby = { "rubocop" },
},
```

### Adding a linter

Add the linter tool name to `ensure_installed` in `lua/plugins/lsp.lua`, then
add a filetype mapping in `lua/plugins/linting.lua`:

```lua
lint.linters_by_ft = {
    -- existing entries...
    ruby = { "rubocop" },
}
```

### Changing the colorscheme

Press `<leader>tt` to open the theme picker with live preview. The selected
theme is persisted across sessions. The following themes are bundled:

- **tokyonight** (night variant, default comments in orange)
- **catppuccin** (mocha, macchiato, frappe, latte)
- **rose-pine** (main, moon, dawn)
- **kanagawa** (wave, dragon, lotus)
- **everforest**

### Changing keybindings

Core keybindings live in `lua/core/keymaps.lua`. Plugin-specific keybindings
are defined in each plugin's spec file (in the `keys` table), which also
controls lazy-loading. Press `<leader>sk` to search all keymaps via Telescope,
or press the leader key and wait for which-key to show available continuations.
