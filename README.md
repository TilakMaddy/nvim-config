# Neovim Config

A modular Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), heavily extended with lazy.nvim, 15+ language servers, AI integration, and a Telescope-driven workflow.

## Highlights

- **LSP for everything** -- Go, Python, TypeScript, Rust, C/C++, Elixir, PHP/Blade, Lua, Deno, Svelte, Gleam, Solidity, Tailwind, ESLint. Auto-installed via Mason.
- **AI assistant** -- Avante.nvim with Claude (via OpenRouter). `<leader>aa` to toggle.
- **Fuzzy finder** -- Telescope + FZF-native. `<leader>sf` for git files, `<leader>sg` for live grep.
- **Fast completion** -- blink.cmp (Rust-powered) with LuaSnip snippets.
- **Format & lint on save** -- conform.nvim + nvim-lint (stylua, prettierd, clang-format, ruff, golangci-lint).
- **File navigation** -- nvim-tree (`<leader>fj`), Grapple tagging (`<leader>ha`), Oil (`-`), Flash motion (`s`).
- **5 themes** -- tokyonight, catppuccin, rose-pine, kanagawa, everforest. `<leader>tt` to pick, persists across sessions.
- **Git** -- gitsigns in the sign column, vim-fugitive (`<leader>gs`), Lazygit (`<leader>gg`).
- **Floating terminal** -- `<C-\>` to toggle.
- **Treesitter** -- syntax highlighting, textobjects (`af`/`if` for functions, `ac`/`ic` for classes), structural navigation.

## Install

```bash
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone
git clone https://github.com/<your-username>/nvim-config.git ~/.config/nvim

# Launch -- lazy.nvim handles the rest
nvim
```

### Dependencies

**Required:** Neovim 0.10+, Nerd Font, git, make, ripgrep, npm/Node.js

**Optional:** [Lazygit](https://github.com/jesseduffield/lazygit), fd, ImageMagick, Kitty terminal

### Post-install

1. Wait for lazy.nvim to finish installing plugins
2. Run `:Mason` to verify language servers are installed
3. (Optional) Add `export OPENROUTER_API_KEY="..."` to `~/.zshrc` for Avante AI

## Key Bindings

Leader is **Space**. Press it and wait for which-key to show options.

| Key | Action |
|---|---|
| `<leader>sf` | Find git files |
| `<leader>sg` | Live grep |
| `<leader><leader>` | Open buffers |
| `gd` / `gr` | Go to definition / references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |
| `<leader>fj` | Toggle file tree |
| `<leader>ha` | Tag file (Grapple) |
| `<leader>aa` | Toggle AI sidebar |
| `<leader>gg` | Lazygit |
| `<leader>tt` | Theme picker |
| `<C-\>` | Floating terminal |
| `s` | Flash jump |

## Documentation

Full documentation lives in [`docs/`](docs/README.md):

| Doc | Covers |
|---|---|
| [docs/README.md](docs/README.md) | Architecture, directory layout, customization guide |
| [docs/keymaps.md](docs/keymaps.md) | Every keybinding across all plugins |
| [docs/lsp.md](docs/lsp.md) | LSP servers, completion, formatting, linting |
| [docs/plugins.md](docs/plugins.md) | All ~40 plugins with config details |
| [docs/navigation.md](docs/navigation.md) | Telescope, nvim-tree, Grapple, Oil, Flash |
| [docs/ui.md](docs/ui.md) | Themes, statusline, notifications, terminal |
| [docs/languages.md](docs/languages.md) | Per-language setup for 14 supported languages |

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries -- [intro video](https://youtu.be/m8C0Cq9Uv9o)
- [lazy.nvim](https://github.com/folke/lazy.nvim) by folke
- [Lazygit](https://github.com/jesseduffield/lazygit) by Jesse Duffield
