# Neovim Configuration

A modular Neovim configuration built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

**Leader key: Space**

## What's in it

- **15+ language servers** auto-installed via Mason (Go, Python, TypeScript, Rust, C/C++, Elixir, PHP, Lua, Deno, Svelte, Gleam, Solidity, Tailwind, ESLint)
- **AI coding** with Avante.nvim (Claude via OpenRouter)
- **Fuzzy everything** through Telescope with FZF-native sorting
- **Fast completion** via blink.cmp (Rust-powered) with LSP, snippets, path, and buffer sources
- **Format on save** with conform.nvim, **lint on save** with nvim-lint
- **5 bundled themes** with persistent selection (tokyonight, catppuccin, rose-pine, kanagawa, everforest)
- **File navigation** four ways: nvim-tree, Grapple tagging, Oil buffer editing, Telescope
- **Flash.nvim** for label-based cursor jumping
- **Treesitter** syntax, textobjects, and structural navigation
- **Floating terminal**, **Lazygit**, and **notification system** via snacks.nvim
- **In-editor images** via Kitty protocol + ImageMagick

---

## Requirements

| Required | Purpose |
|---|---|
| Neovim 0.10+ | Native `vim.lsp.config`, `after/lsp/` support |
| Nerd Font | Icons everywhere |
| git | Plugins, Grapple scope |
| make | telescope-fzf-native, LuaSnip, Avante builds |
| ripgrep (`rg`) | Telescope live grep, todo-comments |
| npm / Node.js | Markdown preview, some LSP servers |

| Optional | Purpose |
|---|---|
| Lazygit | Git UI via `<leader>gg` |
| fd | Faster file finding for Telescope |
| ImageMagick | SVG rendering in-editor |
| Kitty terminal | Image protocol backend |

---

## Directory Layout

```
~/.config/nvim/
├── init.lua                     Entry point: leader key, core modules, lazy.nvim bootstrap
├── lua/
│   ├── core/
│   │   ├── options.lua          Editor settings (4-space tabs, relative numbers, no wrap, etc.)
│   │   ├── keymaps.lua          Core bindings (kj escape, window nav, diagnostics)
│   │   └── autocmds.lua         Yank highlight, .blade.php filetype detection
│   └── plugins/
│       ├── lsp.lua              LSP + Mason + mason-tool-installer pipeline
│       ├── completion.lua       blink.cmp + LuaSnip
│       ├── treesitter.lua       Syntax, textobjects, indent
│       ├── telescope.lua        Fuzzy finder + fzf-native
│       ├── colorscheme.lua      5 themes + persistent picker
│       ├── formatting.lua       conform.nvim (format on save)
│       ├── linting.lua          nvim-lint (ruff, golangci-lint)
│       ├── navigation.lua       nvim-tree + Grapple
│       ├── git.lua              gitsigns + vim-fugitive
│       ├── editor.lua           which-key, autopairs, todo-comments, color highlights
│       ├── snacks.lua           Notifier, terminal, Lazygit, bigfile
│       ├── mini.lua             mini.ai, mini.surround, mini.statusline
│       ├── flash.lua            Label-based motion
│       ├── oil.lua              Buffer-based file manager
│       ├── undotree.lua         Undo history visualizer
│       ├── avante.lua           AI assistant (Claude via OpenRouter)
│       ├── image.lua            In-editor image rendering
│       ├── markdown-preview.lua Browser-based markdown preview
│       ├── lang-rust.lua        rustaceanvim
│       ├── lang-elixir.lua      elixir-tools.nvim
│       └── lang-php.lua         blade-nav.nvim
├── after/lsp/                   Per-server LSP settings (auto-merged by Neovim 0.10+)
│   ├── lua_ls.lua               Call snippet replacement
│   ├── gopls.lua                gofumpt, staticcheck, unused params
│   ├── ts_ls.lua                Root markers: package.json, tsconfig.json
│   ├── denols.lua               Root markers: deno.json, deno.jsonc
│   ├── clangd.lua               UTF-16 offset encoding
│   ├── solidity.lua             Hardhat/Foundry support
│   ├── pyright.lua
│   ├── phpactor.lua
│   ├── svelte.lua
│   └── gleam.lua
└── doc/
    └── kickstart.txt            Upstream help file
```

---

## How It Works

```
init.lua
  │
  ├─ vim.g.mapleader = " "
  ├─ require("core.options")       ← editor settings
  ├─ require("core.keymaps")       ← core bindings
  ├─ require("core.autocmds")      ← autocommands
  │
  └─ require("lazy").setup({
       spec = { import = "plugins" }   ← auto-discovers lua/plugins/*.lua
     })
       │
       └─ lazy.nvim installs, resolves dependencies, applies lazy-loading
            │
            └─ Neovim 0.10+ loads after/lsp/*.lua for per-server config
```

**Key decisions:**
- netrw disabled -- nvim-tree and Oil replace it
- Python/Ruby/Perl/Node providers disabled -- faster startup
- 7 built-in plugins disabled (gzip, matchit, matchparen, tarPlugin, tohtml, tutor, zipPlugin)
- Swap files off, persistent undo on (`undofile = true`)
- System clipboard via `vim.schedule` to avoid blocking startup
- Theme persisted to `~/.local/share/nvim/theme.txt`

---

## Key Bindings at a Glance

### General

| Key | Action |
|---|---|
| `kj` | Escape insert mode |
| `<Esc>` | Clear search highlights |
| `<C-h/j/k/l>` | Navigate windows |
| `<C-\>` | Toggle floating terminal |
| `<leader>q` | Diagnostics quickfix |
| `<leader>pd` | Popup diagnostics |

### Search (Telescope)

| Key | Action |
|---|---|
| `<leader>sf` | Git files |
| `<leader>saf` | All files |
| `<leader>sg` | Live grep |
| `<leader>sG` | Live grep (include hidden/ignored) |
| `<leader>sD` | Grep in specific directory |
| `<leader>sw` | Grep current word |
| `<leader>sd` | Diagnostics |
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Recent files |
| `<leader>sn` | Neovim config files |
| `<leader>sF` | Files in directory |
| `<leader>s/` | Grep in open files |
| `<leader>/` | Fuzzy find in current buffer |
| `<leader><leader>` | Open buffers |

### LSP (active when server attached)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>th` | Toggle inlay hints |
| `<leader>f` | Format buffer |

### Navigation

| Key | Action |
|---|---|
| `<leader>fj` | Toggle nvim-tree |
| `<leader>ff` | Find current file in tree |
| `<leader>ha` | Grapple: toggle tag |
| `<leader>hf` | Grapple: view tags |
| `<C-n>` / `<C-p>` | Grapple: cycle tags |
| `-` | Oil: open parent directory |
| `s` | Flash jump |
| `S` | Flash treesitter jump |

### Git & AI

| Key | Action |
|---|---|
| `<leader>gs` | Git status (Fugitive) |
| `<leader>gg` | Lazygit |
| `<leader>aa` | Avante: toggle AI sidebar |
| `<leader>an` | Avante: new chat |
| `<leader>am` | Avante: switch model |

### UI

| Key | Action |
|---|---|
| `<leader>tt` | Theme picker (persistent) |
| `<leader>u` | Toggle undotree |
| `<leader>nh` | Notification history |
| `<leader>mp` | Markdown preview |

> Full reference: [keymaps.md](keymaps.md)

---

## Mason Auto-Installed Tools

| Category | Tools |
|---|---|
| LSP servers | lua-language-server, gopls, pyright, typescript-language-server, deno, clangd, tailwindcss-language-server, eslint-lsp, phpactor |
| Formatters | stylua, clang-format, prettierd |
| Linters | ruff, golangci-lint |

Servers **not** managed by Mason: `rust_analyzer` (managed by rustaceanvim), `elixirls`/`nextls` (managed by elixir-tools.nvim), `gleam` (bundled with compiler).

---

## Completion

blink.cmp (Rust-powered) with LuaSnip snippets:

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / previous item |
| `<Tab>` / `<C-y>` | Accept |
| `<C-Space>` | Show completions |
| `<C-e>` | Hide |
| `<C-l>` / `<C-h>` | Snippet forward / backward |
| `<C-b>` / `<C-f>` | Scroll docs |

Sources: LSP, snippets, path, buffer. Extra: `lazydev` for Lua, `blade-nav` for PHP/Blade.

---

## Formatting & Linting

**Format on save** via conform.nvim (disabled for C/C++):

| Filetype | Formatter |
|---|---|
| Lua | stylua |
| C/C++ | clang-format (manual only) |
| JS/TS | prettierd (fallback: prettier) |
| PHP | pint (fallback: php_cs_fixer) |

**Lint on save** via nvim-lint:

| Filetype | Linter |
|---|---|
| Python | ruff |
| Go | golangci-lint |

---

## Quick Start

```bash
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone
git clone <your-repo-url> ~/.config/nvim

# Launch -- lazy.nvim installs everything automatically
nvim
```

After first launch:
1. Wait for the lazy.nvim install window to finish
2. Run `:Mason` to verify LSP servers are installed
3. (Optional) Set `OPENROUTER_API_KEY` in `~/.zshrc` for Avante AI

---

## Customization

### Add a plugin

Create a file in `lua/plugins/`:

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  opts = {},
}
```

### Add a language server

1. Add the Mason package name to `ensure_installed` in `lua/plugins/lsp.lua`
2. Create `after/lsp/<server>.lua` returning a settings table:

```lua
-- after/lsp/rust_analyzer.lua
return {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
    },
  },
}
```

### Add a formatter

Add to `ensure_installed` in `lsp.lua`, then map in `lua/plugins/formatting.lua`:

```lua
formatters_by_ft = {
  ruby = { "rubocop" },
}
```

### Change the theme

Press `<leader>tt` -- picks with live preview, persists across sessions.

---

## Detailed Documentation

| Document | What it covers |
|---|---|
| [keymaps.md](keymaps.md) | Every keybinding across all plugins |
| [lsp.md](lsp.md) | LSP servers, completion, formatting, linting |
| [plugins.md](plugins.md) | All ~40 plugins with config details |
| [navigation.md](navigation.md) | Telescope, nvim-tree, Grapple, Oil, Flash |
| [ui.md](ui.md) | Themes, statusline, notifications, terminal |
| [languages.md](languages.md) | Per-language setup for all 14 supported languages |
