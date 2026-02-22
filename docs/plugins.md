# Neovim Plugin Documentation

Complete reference for every plugin in this Neovim configuration. All plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

---

## Summary Table

| Plugin | Category | Load Event | Config File |
|--------|----------|------------|-------------|
| `nvim-lua/plenary.nvim` | Core Infrastructure | Dependency | `telescope.lua`, `editor.lua`, `lang-elixir.lua` |
| `neovim/nvim-lspconfig` | LSP & Completion | `BufReadPre`, `BufNewFile` | `lsp.lua` |
| `williamboman/mason.nvim` | LSP & Completion | `Mason` / `MasonInstall` cmd | `lsp.lua` |
| `williamboman/mason-lspconfig.nvim` | LSP & Completion | Dependency | `lsp.lua` |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | LSP & Completion | Dependency | `lsp.lua` |
| `saghen/blink.cmp` | LSP & Completion | `InsertEnter` | `completion.lua` |
| `folke/lazydev.nvim` | LSP & Completion | `ft = lua` | `lsp.lua` |
| `Bilal2453/luvit-meta` | LSP & Completion | Lazy (dependency) | `lsp.lua` |
| `L3MON4D3/LuaSnip` | LSP & Completion | Dependency of blink.cmp | `completion.lua` |
| `j-hui/fidget.nvim` | LSP & Completion | -- | -- |
| `nvim-treesitter/nvim-treesitter` | Syntax & Code Intelligence | Eager (`lazy = false`) | `treesitter.lua` |
| `nvim-treesitter/nvim-treesitter-textobjects` | Syntax & Code Intelligence | Dependency | `treesitter.lua` |
| `folke/todo-comments.nvim` | Syntax & Code Intelligence | `BufReadPost`, `BufNewFile` | `editor.lua` |
| `nvim-telescope/telescope.nvim` | Search & Navigation | `Telescope` cmd / keys | `telescope.lua` |
| `nvim-telescope/telescope-fzf-native.nvim` | Search & Navigation | Dependency | `telescope.lua` |
| `nvim-tree/nvim-tree.lua` | Search & Navigation | `NvimTreeToggle` / `NvimTreeFindFile` cmd / keys | `navigation.lua` |
| `cbochs/grapple.nvim` | Search & Navigation | Keys | `navigation.lua` |
| `stevearc/oil.nvim` | Search & Navigation | `Oil` cmd / keys | `oil.lua` |
| `folke/flash.nvim` | Search & Navigation | `VeryLazy` / keys | `flash.lua` |
| `folke/which-key.nvim` | Editor Enhancement | `VeryLazy` | `editor.lua` |
| `windwp/nvim-autopairs` | Editor Enhancement | `InsertEnter` | `editor.lua` |
| `brenoprata10/nvim-highlight-colors` | Editor Enhancement | `BufReadPost`, `BufNewFile` | `editor.lua` |
| `echasnovski/mini.nvim` | Editor Enhancement | Eager | `mini.lua` |
| `mbbill/undotree` | Editor Enhancement | `UndotreeToggle` cmd / keys | `undotree.lua` |
| `lewis6991/gitsigns.nvim` | Git | `BufReadPre`, `BufNewFile` | `git.lua` |
| `tpope/vim-fugitive` | Git | `Git` cmd / keys | `git.lua` |
| `stevearc/conform.nvim` | Formatting & Linting | `BufWritePre` / `ConformInfo` cmd / keys | `formatting.lua` |
| `mfussenegger/nvim-lint` | Formatting & Linting | `BufReadPre`, `BufNewFile` | `linting.lua` |
| `folke/tokyonight.nvim` | UI & Appearance | Eager (priority 1000) | `colorscheme.lua` |
| `catppuccin/nvim` | UI & Appearance | Eager | `colorscheme.lua` |
| `rose-pine/neovim` | UI & Appearance | Eager | `colorscheme.lua` |
| `rebelot/kanagawa.nvim` | UI & Appearance | Eager | `colorscheme.lua` |
| `sainnhe/everforest` | UI & Appearance | Eager | `colorscheme.lua` |
| `folke/snacks.nvim` | UI & Appearance | Eager (`lazy = false`, priority 1000) | `snacks.lua` |
| `nvim-tree/nvim-web-devicons` | UI & Appearance | Dependency | `telescope.lua`, `navigation.lua` |
| `nickjvandyke/opencode.nvim` | AI | Keys | `opencode.lua` |
| `mrcjkb/rustaceanvim` | Language-Specific | Eager (`lazy = false`) | `lang-rust.lua` |
| `elixir-tools/elixir-tools.nvim` | Language-Specific | `BufReadPre`, `BufNewFile` | `lang-elixir.lua` |
| `ricardoramirezr/blade-nav.nvim` | Language-Specific | `ft = blade, php` | `lang-php.lua` |
| `3rd/image.nvim` | Media & Preview | `VeryLazy` | `image.lua` |
| `iamcco/markdown-preview.nvim` | Media & Preview | `ft = markdown` / cmd / keys | `markdown-preview.lua` |

---

## Core Infrastructure

### `nvim-lua/plenary.nvim`

- **GitHub:** [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- **Purpose:** General-purpose Lua utility library for Neovim. Provides async primitives, path utilities, testing helpers, and other foundational functions used by many plugins.
- **Loading strategy:** Loaded as a dependency of telescope.nvim, todo-comments.nvim, and elixir-tools.nvim. Never loaded on its own.
- **Dependencies:** None.
- **Key configuration choices:** None -- used as-is with default settings.
- **Keybindings:** None.

---

## LSP & Completion

### `neovim/nvim-lspconfig`

- **GitHub:** [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- **Purpose:** Quickstart configurations for the Neovim built-in LSP client. Provides sensible defaults for dozens of language servers, reducing boilerplate setup.
- **Loading strategy:** Lazy-loaded on events `BufReadPre` and `BufNewFile` so it activates as soon as a real file is opened.
- **Dependencies:**
  - `williamboman/mason.nvim`
  - `williamboman/mason-lspconfig.nvim`
  - `WhoIsSethDaniel/mason-tool-installer.nvim`
  - `folke/lazydev.nvim`
  - `Bilal2453/luvit-meta`
- **Key configuration choices:**
  - Broadcasts `blink.cmp` capabilities to every LSP server via `vim.lsp.config("*", { capabilities })`, ensuring completion sources are available everywhere.
  - On `LspAttach`, sets up buffer-local keymaps that integrate with Telescope for definitions, references, implementations, symbols, and diagnostics.
  - Highlights references under the cursor on `CursorHold` when the server supports `textDocument/documentHighlight`, and clears them on cursor movement.
  - Supports toggling inlay hints via `<leader>th` when the server supports `textDocument/inlayHint`.
  - Mason tool installer ensures a curated set of LSP servers, formatters, and linters are always installed: `lua-language-server`, `gopls`, `pyright`, `typescript-language-server`, `deno`, `clangd`, `tailwindcss-language-server`, `eslint-lsp`, `phpactor`, `stylua`, `clang-format`, `prettierd`, `ruff`, `golangci-lint`.
  - `mason-lspconfig` uses `automatic_enable` with `rust_analyzer`, `rescriptls`, and `stylua_lsp` excluded (Rust is handled by rustaceanvim instead).
- **Keybindings (buffer-local on LspAttach):**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `gd` | n | Go to definition (Telescope) |
  | `gr` | n | Go to references (Telescope) |
  | `gI` | n | Go to implementation (Telescope) |
  | `gD` | n | Go to declaration |
  | `<leader>D` | n | Type definition (Telescope) |
  | `<leader>ds` | n | Document symbols (Telescope) |
  | `<leader>ws` | n | Workspace symbols (Telescope) |
  | `<leader>rn` | n | Rename symbol |
  | `<leader>ca` | n, x | Code action |
  | `<leader>th` | n | Toggle inlay hints |

---

### `williamboman/mason.nvim`

- **GitHub:** [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- **Purpose:** Portable package manager for Neovim that installs and manages LSP servers, DAP servers, linters, and formatters.
- **Loading strategy:** Lazy-loaded on commands `Mason` and `MasonInstall`. Also set up programmatically inside the lspconfig `config` function.
- **Dependencies:** None.
- **Key configuration choices:** Uses default configuration (`config = true`).
- **Keybindings:** None (use `:Mason` command to open the UI).

---

### `williamboman/mason-lspconfig.nvim`

- **GitHub:** [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- **Purpose:** Bridges mason.nvim and nvim-lspconfig, automatically enabling LSP servers that Mason installs.
- **Loading strategy:** Loaded as a dependency of nvim-lspconfig.
- **Dependencies:** `mason.nvim`, `nvim-lspconfig`.
- **Key configuration choices:**
  - `automatic_enable` is on, meaning any Mason-installed server is automatically started.
  - Excludes `rust_analyzer` (managed by rustaceanvim), `rescriptls`, and `stylua_lsp` from automatic enable.
- **Keybindings:** None.

---

### `WhoIsSethDaniel/mason-tool-installer.nvim`

- **GitHub:** [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)
- **Purpose:** Ensures a specific list of Mason tools (servers, formatters, linters) are always installed, acting as a declarative manifest.
- **Loading strategy:** Loaded as a dependency of nvim-lspconfig.
- **Dependencies:** `mason.nvim`.
- **Key configuration choices:**
  - `ensure_installed` list covers:
    - **LSP servers:** lua-language-server, gopls, pyright, typescript-language-server, deno, clangd, tailwindcss-language-server, eslint-lsp, phpactor
    - **Formatters:** stylua, clang-format, prettierd
    - **Linters:** ruff, golangci-lint
- **Keybindings:** None.

---

### `saghen/blink.cmp`

- **GitHub:** [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
- **Purpose:** Fast, modern autocompletion engine for Neovim. Provides fuzzy matching, snippet expansion, and multiple completion sources with a lightweight footprint.
- **Loading strategy:** Lazy-loaded on `InsertEnter`. Pinned to version `1.*`.
- **Dependencies:**
  - `L3MON4D3/LuaSnip` (v2.*, builds with `make install_jsregexp` on non-Windows)
- **Key configuration choices:**
  - Uses `luasnip` as the snippet preset.
  - Custom keymap preset (`"none"`) with explicit bindings for navigation, acceptance, and snippet traversal.
  - Auto-brackets enabled on accept.
  - Documentation auto-shows on completion.
  - Completion sources: `lsp`, `snippets`, `path`, `buffer` (default); adds `lazydev` for Lua files and `blade-nav` for blade/php files.
  - Custom providers registered for `LazyDev` (score offset 100 to prioritize) and `Blade`.
- **Keybindings (insert mode, during completion):**

  | Key | Action |
  |-----|--------|
  | `<C-n>` / `<Down>` | Select next item |
  | `<C-p>` / `<Up>` | Select previous item |
  | `<C-b>` | Scroll documentation up |
  | `<C-f>` | Scroll documentation down |
  | `<Tab>` / `<C-y>` | Select and accept |
  | `<C-Space>` | Show completion menu |
  | `<C-e>` | Hide completion menu |
  | `<C-l>` | Jump to next snippet placeholder |
  | `<C-h>` | Jump to previous snippet placeholder |

---

### `L3MON4D3/LuaSnip`

- **GitHub:** [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Purpose:** Snippet engine written in Lua. Provides programmable snippets with dynamic nodes, choice nodes, and regex triggers.
- **Loading strategy:** Loaded as a dependency of blink.cmp. Pinned to version `v2.*`.
- **Dependencies:** None.
- **Key configuration choices:** Builds `jsregexp` via `make install_jsregexp` on platforms that support it (skipped on Windows or when `make` is unavailable).
- **Keybindings:** Snippet traversal is handled by blink.cmp (`<C-l>` forward, `<C-h>` backward).

---

### `folke/lazydev.nvim`

- **GitHub:** [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim)
- **Purpose:** Provides proper completion and type annotations for the Neovim Lua API, plugin APIs, and `vim.uv` (libuv bindings) when editing Lua files.
- **Loading strategy:** Lazy-loaded on filetype `lua`.
- **Dependencies:** `Bilal2453/luvit-meta` (provides libuv type definitions).
- **Key configuration choices:**
  - Library includes `luvit-meta/library` triggered by the pattern `vim%.uv`, so libuv types are only loaded when relevant.
  - Integrated into blink.cmp as a custom provider with `score_offset = 100` to prioritize Neovim API completions over generic Lua completions.
- **Keybindings:** None.

---

### `Bilal2453/luvit-meta`

- **GitHub:** [Bilal2453/luvit-meta](https://github.com/Bilal2453/luvit-meta)
- **Purpose:** Provides Lua type definitions for libuv (the async I/O library underlying `vim.uv`), enabling accurate completions and hover docs.
- **Loading strategy:** `lazy = true` -- only loaded when lazydev.nvim requests it.
- **Dependencies:** None.
- **Key configuration choices:** None.
- **Keybindings:** None.

---

## Syntax & Code Intelligence

### `nvim-treesitter/nvim-treesitter`

- **GitHub:** [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- **Purpose:** Provides incremental parsing via Tree-sitter, enabling accurate syntax highlighting, indentation, code folding, and the foundation for textobjects and other structural code features.
- **Loading strategy:** Eager (`lazy = false`). Runs `:TSUpdate` on build.
- **Dependencies:**
  - `nvim-treesitter/nvim-treesitter-textobjects`
- **Key configuration choices:**
  - Registers the `blade` filetype for treesitter.
  - Adds a compatibility shim for `blade-nav.nvim` which relies on the removed `parsers.get_parser` API.
  - `ensure_installed` covers 20 languages: bash, c, cpp, css, diff, elixir, go, html, javascript, json, lua, luadoc, markdown, markdown_inline, php, python, query, rust, svelte, typescript, vim, vimdoc.
  - `auto_install = true` so any unrecognized filetype triggers parser installation.
  - Both `highlight` and `indent` modules are enabled.
- **Keybindings:** None directly (textobject keymaps are defined via treesitter-textobjects below).

---

### `nvim-treesitter/nvim-treesitter-textobjects`

- **GitHub:** [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- **Purpose:** Adds Tree-sitter-aware textobjects for selecting, moving between, and swapping code structures like functions, classes, parameters, and loops.
- **Loading strategy:** Loaded as a dependency of nvim-treesitter.
- **Dependencies:** `nvim-treesitter`.
- **Key configuration choices:**
  - `select.lookahead = true` so textobject selections look ahead to the next match if the cursor is not currently inside one.
  - Defines select, move, and swap operations via manual keymap registration (not through the deprecated nvim-treesitter `setup()` textobjects table).
- **Keybindings:**

  **Selection (visual/operator-pending mode):**

  | Key | Textobject |
  |-----|------------|
  | `af` | Function (outer) |
  | `if` | Function (inner) |
  | `ac` | Class (outer) |
  | `ic` | Class (inner) |
  | `aa` | Parameter (outer) |
  | `ia` | Parameter (inner) |
  | `al` | Loop (outer) |
  | `il` | Loop (inner) |

  **Movement (normal/visual/operator-pending mode):**

  | Key | Description |
  |-----|-------------|
  | `]f` | Next function start |
  | `[f` | Previous function start |
  | `]c` | Next class start |
  | `[c` | Previous class start |
  | `]a` | Next argument |
  | `[a` | Previous argument |

  **Swap (normal mode):**

  | Key | Description |
  |-----|-------------|
  | `<leader>xa` | Swap with next argument |
  | `<leader>xA` | Swap with previous argument |

---

### `folke/todo-comments.nvim`

- **GitHub:** [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- **Purpose:** Highlights and searches for TODO, FIXME, HACK, NOTE, and other comment annotations across the project. Integrates with Telescope and quickfix for navigation.
- **Loading strategy:** Lazy-loaded on events `BufReadPost` and `BufNewFile`.
- **Dependencies:** `nvim-lua/plenary.nvim`.
- **Key configuration choices:**
  - `signs = false` disables sign column indicators for todo comments, keeping the gutter clean.
- **Keybindings:** None defined in config (uses built-in commands like `:TodoTelescope`).

---

## Search & Navigation

### `nvim-telescope/telescope.nvim`

- **GitHub:** [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- **Purpose:** Highly extensible fuzzy finder for files, buffers, grep results, LSP symbols, and more. The central search interface for the entire configuration.
- **Loading strategy:** Lazy-loaded on the `Telescope` command and via numerous `keys` mappings.
- **Dependencies:**
  - `nvim-lua/plenary.nvim`
  - `nvim-telescope/telescope-fzf-native.nvim` (conditional on `make` being available)
  - `nvim-tree/nvim-web-devicons` (conditional on `vim.g.nerd_font`)
- **Key configuration choices:**
  - `file_ignore_patterns` excludes `node_modules/`, `.git/`, `*.lock`, `dist/`, `build/`, `target/`, `vendor/`, and `*.min.js` for faster searches.
  - `sorting_strategy = "ascending"` with `prompt_position = "top"` for a top-down layout.
  - `path_display = { "truncate" }` to keep results readable.
  - Preview limited to files under 1MB with a 250ms timeout.
  - FZF extension loaded with smart_case and overrides for both generic and file sorters.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>sh` | n | Search help tags |
  | `<leader>sk` | n | Search keymaps |
  | `<leader>saf` | n | Search all files (find_files) |
  | `<leader>sf` | n | Search git files |
  | `<leader>ss` | n | Search Telescope builtins |
  | `<leader>sw` | n | Search current word (grep_string) |
  | `<leader>sg` | n | Search by grep (live_grep) |
  | `<leader>sG` | n | Search by grep (include ignored/hidden) |
  | `<leader>sD` | n | Search directory (scoped grep) |
  | `<leader>sd` | n | Search diagnostics (vertical layout) |
  | `<leader>sr` | n | Resume last search |
  | `<leader>s.` | n | Search recent files |
  | `<leader><leader>` | n | Find existing buffers |
  | `<leader>/` | n | Fuzzy search in current buffer (dropdown) |
  | `<leader>s/` | n | Live grep in open files |
  | `<leader>sn` | n | Search Neovim config files |
  | `<leader>sF` | n | Find files in a prompted directory |

---

### `nvim-telescope/telescope-fzf-native.nvim`

- **GitHub:** [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- **Purpose:** C-compiled FZF sorter for Telescope that dramatically improves fuzzy matching performance compared to the default Lua sorter.
- **Loading strategy:** Built with `make` and loaded as a Telescope extension. Conditional on `make` being available on the system.
- **Dependencies:** `telescope.nvim`.
- **Key configuration choices:**
  - `fuzzy = true`, `override_generic_sorter = true`, `override_file_sorter = true`, `case_mode = "smart_case"`.
- **Keybindings:** None.

---

### `nvim-tree/nvim-tree.lua`

- **GitHub:** [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- **Purpose:** File explorer sidebar with tree view. Provides a visual directory structure for browsing, creating, renaming, and deleting files.
- **Loading strategy:** Lazy-loaded on commands `NvimTreeToggle` and `NvimTreeFindFile`, and on key mappings. Pinned to latest stable version (`version = "*"`).
- **Dependencies:** `nvim-tree/nvim-web-devicons`.
- **Key configuration choices:**
  - Case-sensitive sorting.
  - Tree view width of 30 columns.
  - Empty directories are grouped together (`group_empty = true`).
  - Dotfiles are hidden by default (`filters.dotfiles = true`).
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>fj` | n | Toggle file tree |
  | `<leader>ff` | n | Find current file in tree |

---

### `cbochs/grapple.nvim`

- **GitHub:** [cbochs/grapple.nvim](https://github.com/cbochs/grapple.nvim)
- **Purpose:** Fast file tagging and switching. Allows marking files for quick access, similar to harpoon but with git-scoped tags and a numbered quick-select interface.
- **Loading strategy:** Lazy-loaded on key mappings.
- **Dependencies:** `nvim-tree/nvim-web-devicons`.
- **Key configuration choices:**
  - `scope = "git"` -- tags are scoped to the current git repository.
  - `quick_select = "123456789"` -- number keys for quick tag selection in the tags window.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>ha` | n | Toggle tag on current file |
  | `<leader>hf` | n | Open tags finder |
  | `<C-n>` | n | Cycle to next tagged file |
  | `<C-p>` | n | Cycle to previous tagged file |

---

### `stevearc/oil.nvim`

- **GitHub:** [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)
- **Purpose:** File explorer that lets you edit your filesystem like a buffer. Navigate directories, rename files by editing text, and create/delete files with normal Vim operations.
- **Loading strategy:** Lazy-loaded on the `Oil` command and on key mappings.
- **Dependencies:** None.
- **Key configuration choices:**
  - `default_file_explorer = false` -- does not replace netrw (nvim-tree is used as the default tree explorer).
  - `show_hidden = true` in view options.
  - Float window with padding of 4, max width 120, max height 40.
  - `q` mapped to close, `<C-s>` unmapped (to avoid overriding split keybinding).
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `-` | n | Open parent directory in Oil |
  | `q` | n | Close Oil buffer (inside Oil) |

---

### `folke/flash.nvim`

- **GitHub:** [folke/flash.nvim](https://github.com/folke/flash.nvim)
- **Purpose:** Enhanced motion plugin that uses labels for lightning-fast jumps to any visible location. Supports character-based jumps, treesitter-aware selection, and remote operations.
- **Loading strategy:** Lazy-loaded on `VeryLazy` event and on key mappings.
- **Dependencies:** None.
- **Key configuration choices:**
  - `char.jump_labels = true` -- shows labels on f/F/t/T motions.
  - `search.enabled = false` -- does not integrate with `/` search (search remains vanilla).
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `s` | n, x, o | Flash jump |
  | `S` | n, x, o | Flash treesitter selection |
  | `r` | o | Remote flash (operator-pending) |
  | `R` | o, x | Treesitter search |

---

## Editor Enhancement

### `folke/which-key.nvim`

- **GitHub:** [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- **Purpose:** Displays a popup with available keybindings as you type a prefix key, helping discover and remember mappings.
- **Loading strategy:** Lazy-loaded on `VeryLazy`.
- **Dependencies:** None.
- **Key configuration choices:**
  - Icon mappings controlled by `vim.g.nerd_font` (uses icons only when a Nerd Font is available).
  - Defines group labels for key prefixes: `<leader>c` (Code), `<leader>d` (Document), `<leader>r` (Rename), `<leader>s` (Search), `<leader>w` (Workspace), `<leader>t` (Toggle), `<leader>h` (Grapple).
- **Keybindings:** None directly (it annotates other keybindings).

---

### `windwp/nvim-autopairs`

- **GitHub:** [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- **Purpose:** Automatically inserts matching closing brackets, parentheses, quotes, and other paired characters when you type the opening one.
- **Loading strategy:** Lazy-loaded on `InsertEnter`.
- **Dependencies:** None.
- **Key configuration choices:** Uses default configuration (`config = true`).
- **Keybindings:** None (operates automatically in insert mode).

---

### `brenoprata10/nvim-highlight-colors`

- **GitHub:** [brenoprata10/nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors)
- **Purpose:** Highlights color codes (hex, rgb, hsl, named colors) inline in the buffer so you can visually see what color a value represents.
- **Loading strategy:** Lazy-loaded on events `BufReadPost` and `BufNewFile`.
- **Dependencies:** None.
- **Key configuration choices:**
  - `render = "virtual"` -- displays colors as virtual text rather than background highlights.
  - `enable_tailwind = false` -- Tailwind CSS color class detection is disabled.
- **Keybindings:** None.

---

### `echasnovski/mini.nvim`

- **GitHub:** [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim)
- **Purpose:** Collection of minimal, focused Lua modules. This configuration uses three modules: `mini.ai` (extended textobjects), `mini.surround` (surround operations), and `mini.statusline` (status line).
- **Loading strategy:** Eager (no lazy loading specified).
- **Dependencies:** None.
- **Key configuration choices:**
  - **mini.ai:** `n_lines = 500` -- searches up to 500 lines for textobject matches (extends the `a`/`i` textobject family with bracket-aware, argument-aware selections).
  - **mini.surround:** Default configuration -- adds `sa` (add surrounding), `sd` (delete surrounding), `sr` (replace surrounding), `sf` (find surrounding), `sF` (find surrounding left), `sh` (highlight surrounding).
  - **mini.statusline:** Uses icons when `vim.g.nerd_font` is set. Overrides `section_location` to show `line:column` in a compact `%2l:%-2v` format.
- **Keybindings:** mini.surround defaults (`sa`, `sd`, `sr`, `sf`, `sF`, `sh` in normal/visual modes). mini.ai textobjects are available via standard `a`/`i` motions.

---

### `mbbill/undotree`

- **GitHub:** [mbbill/undotree](https://github.com/mbbill/undotree)
- **Purpose:** Visualizes the Vim undo history as a tree, allowing you to navigate and restore any previous state, including branches that linear undo cannot reach.
- **Loading strategy:** Lazy-loaded on the `UndotreeToggle` command and key mapping.
- **Dependencies:** None.
- **Key configuration choices:**
  - `undotree_SetFocusWhenToggle = 1` -- automatically focuses the undotree window when toggled.
  - `undotree_WindowLayout = 2` -- uses layout 2 (tree on the left, diff below).
  - `undotree_ShortIndicators = 1` -- uses short time indicators to save space.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>u` | n | Toggle Undotree |

---

## Git

### `lewis6991/gitsigns.nvim`

- **GitHub:** [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- **Purpose:** Adds git change indicators in the sign column (added, modified, deleted lines) and provides inline blame, hunk staging, and other git operations without leaving the editor.
- **Loading strategy:** Lazy-loaded on events `BufReadPre` and `BufNewFile`.
- **Dependencies:** None.
- **Key configuration choices:**
  - Custom sign characters: `+` (add), `~` (change), `_` (delete), `‾` (top delete), `~` (change-delete).
- **Keybindings:** None explicitly defined (gitsigns provides many default keymaps via its own setup).

---

### `tpope/vim-fugitive`

- **GitHub:** [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
- **Purpose:** Comprehensive Git wrapper for Vim. Provides `:Git` command for any git operation, plus specialized views for status, blame, diff, log, and merge conflict resolution.
- **Loading strategy:** Lazy-loaded on the `Git` command and key mapping.
- **Dependencies:** None.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>gs` | n | Open Git status |

---

## Formatting & Linting

### `stevearc/conform.nvim`

- **GitHub:** [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- **Purpose:** Lightweight formatting engine that runs external formatters and falls back to LSP formatting. Supports format-on-save with per-filetype formatter configuration.
- **Loading strategy:** Lazy-loaded on `BufWritePre` (for format-on-save), the `ConformInfo` command, and key mapping.
- **Dependencies:** None.
- **Key configuration choices:**
  - `notify_on_error = false` -- suppresses error notifications from failed formatters.
  - Format-on-save enabled with 500ms timeout. Falls back to LSP formatting except for C/C++ files where LSP formatting is explicitly disabled (`"never"`).
  - **Formatters by filetype:**
    - `lua` -> `stylua`
    - `c++` / `cpp` -> `clang-format`
    - `javascript` / `typescript` -> `prettierd` then `prettier` (stop after first success)
    - `php` -> `pint` then `php_cs_fixer` (stop after first success)
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>f` | all modes | Format buffer (async, LSP fallback) |

---

### `mfussenegger/nvim-lint`

- **GitHub:** [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **Purpose:** Asynchronous linting engine that runs external linters and populates the diagnostics list. Complements LSP diagnostics with tool-specific checks.
- **Loading strategy:** Lazy-loaded on events `BufReadPre` and `BufNewFile`.
- **Dependencies:** None.
- **Key configuration choices:**
  - **Linters by filetype:**
    - `python` -> `ruff`
    - `go` -> `golangcilint`
  - Linting triggers on `BufWritePost`, `InsertLeave`, and `BufReadPost` -- only for normal buffers (`buftype == ""`).
- **Keybindings:** None.

---

## UI & Appearance

### `folke/tokyonight.nvim`

- **GitHub:** [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- **Purpose:** Clean, dark colorscheme with multiple style variants (night, storm, day, moon). Also serves as the primary colorscheme loader for this configuration.
- **Loading strategy:** Eager with `priority = 1000` to ensure it loads before any UI rendering. The `init` function applies the saved theme from `~/.local/share/nvim/theme.txt` (defaults to `catppuccin-mocha`).
- **Dependencies:** None.
- **Key configuration choices:**
  - `style = "night"` variant.
  - Custom highlight override: comments are rendered in orange.
  - Theme persistence: the selected theme is saved to `theme.txt` in the Neovim data directory and restored on startup.
  - Theme picker uses Telescope's colorscheme picker with live preview; selected themes are persisted.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>tt` | n | Open theme picker (Telescope with preview, saves selection) |

---

### `catppuccin/nvim`

- **GitHub:** [catppuccin/nvim](https://github.com/catppuccin/nvim)
- **Purpose:** Soothing pastel colorscheme with multiple flavors (latte, frappe, macchiato, mocha). The default theme for this configuration (`catppuccin-mocha`).
- **Loading strategy:** Eager (loaded at startup to be available for the theme picker).
- **Dependencies:** None.
- **Key configuration choices:**
  - `no_italic = true` -- disables all italic styling.
- **Keybindings:** None.

---

### `rose-pine/neovim`

- **GitHub:** [rose-pine/neovim](https://github.com/rose-pine/neovim)
- **Purpose:** Elegant, low-contrast colorscheme inspired by natural tones with dawn, moon, and main variants.
- **Loading strategy:** Eager.
- **Dependencies:** None.
- **Key configuration choices:**
  - `disable_italics = true` -- disables italic styling.
- **Keybindings:** None.

---

### `rebelot/kanagawa.nvim`

- **GitHub:** [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- **Purpose:** Colorscheme inspired by the famous painting "The Great Wave off Kanagawa" with wave, dragon, and lotus variants.
- **Loading strategy:** Eager.
- **Dependencies:** None.
- **Key configuration choices:**
  - `compile = true` -- pre-compiles the theme for faster startup.
  - `commentStyle = { italic = false }` -- comments are not italic.
  - `keywordStyle = { italic = false }` -- keywords are not italic.
- **Keybindings:** None.

---

### `sainnhe/everforest`

- **GitHub:** [sainnhe/everforest](https://github.com/sainnhe/everforest)
- **Purpose:** Green-toned comfortable colorscheme designed to be easy on the eyes during long coding sessions.
- **Loading strategy:** Eager.
- **Dependencies:** None.
- **Key configuration choices:**
  - `everforest_disable_italic_comment = 1` -- disables italic comments (consistent with all other themes in this config).
- **Keybindings:** None.

---

### `folke/snacks.nvim`

- **GitHub:** [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- **Purpose:** Swiss-army-knife utility plugin providing notifications, input prompts, lazygit integration, floating terminal, and big file detection in a single, cohesive package.
- **Loading strategy:** Eager (`lazy = false`, `priority = 1000`).
- **Dependencies:** None.
- **Key configuration choices:**
  - **Notifier:** Enabled with notification width range of 60-100 characters. Notification history window is 90% width and height with word wrap.
  - **Input:** Enabled (replaces `vim.ui.input` with a snacks-styled prompt).
  - **Lazygit:** Enabled with fullscreen window (`width = 0`, `height = 0`).
  - **Bigfile:** Enabled (disables expensive features like treesitter and LSP for large files).
  - **Terminal:** Floating window with rounded border, 80% width and height.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<C-\>` | n, t | Toggle floating terminal |
  | `<leader>nh` | n | Show notification history |
  | `<leader>gg` | n | Open Lazygit |

---

### `nvim-tree/nvim-web-devicons`

- **GitHub:** [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- **Purpose:** Provides filetype-specific icons (Nerd Font glyphs) used by Telescope, nvim-tree, grapple, and the statusline.
- **Loading strategy:** Loaded as a dependency. Conditionally enabled based on `vim.g.nerd_font`.
- **Dependencies:** None.
- **Key configuration choices:** None (default icon set).
- **Keybindings:** None.

---

## AI

### `nickjvandyke/opencode.nvim`

- **GitHub:** [NickvanDyke/opencode.nvim](https://github.com/NickvanDyke/opencode.nvim)
- **Purpose:** Integrates the [opencode](https://opencode.ai) CLI tool into Neovim. Shares editor context (buffers, selections, diagnostics) with the AI assistant and embeds the opencode TUI as a full-screen float.
- **Loading strategy:** Lazy-loaded on key mappings. Pinned to latest stable (`version = "*"`).
- **Dependencies:** `folke/snacks.nvim` (uses snacks.terminal for the embedded TUI).
- **Key configuration choices:**
  - Uses the snacks provider to embed the opencode TUI as a floating terminal.
  - Float window: 95% width/height, rounded border, opaque backdrop, auto-enter on toggle.
  - Scrollback disabled (`scrollback = 0`) to prevent the terminal buffer from scrolling past the TUI.
  - `VimLeavePre` autocmd calls `opencode.stop()` to clean up the server process on exit.
  - Context placeholders (`@this`, `@buffer`, `@diagnostics`, etc.) inject editor state into prompts.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>aa` | n, t | Toggle opencode TUI |
  | `<leader>aa` | v | Ask opencode about visual selection |
  | `<leader>am` | n | Open opencode menu (prompts, commands) |

- **Prerequisite:** The `opencode` CLI must be installed and configured separately (provider/API key setup is done in opencode's own config, not in Neovim).

---

## Language-Specific

### `mrcjkb/rustaceanvim`

- **GitHub:** [mrcjkb/rustaceanvim](https://github.com/mrcjkb/rustaceanvim)
- **Purpose:** Comprehensive Rust development plugin that manages rust-analyzer, provides enhanced hover actions, runnables, debuggables, crate graph visualization, and other Rust-specific features beyond what generic LSP provides.
- **Loading strategy:** Eager (`lazy = false`). Pinned to version `^8`. The plugin auto-detects Rust files and attaches automatically.
- **Dependencies:** None (manages rust-analyzer independently; excluded from mason-lspconfig's `automatic_enable`).
- **Key configuration choices:** Uses defaults -- the plugin is designed to work out of the box with minimal configuration.
- **Keybindings:** None defined explicitly (rustaceanvim provides its own default keymaps on attach).

---

### `elixir-tools/elixir-tools.nvim`

- **GitHub:** [elixir-tools/elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim)
- **Purpose:** All-in-one Elixir development plugin providing NextLS and ElixirLS integration, pipe manipulation commands, macro expansion, and projectionist support.
- **Loading strategy:** Lazy-loaded on events `BufReadPre` and `BufNewFile`. Pinned to latest stable (`version = "*"`).
- **Dependencies:** `nvim-lua/plenary.nvim`.
- **Key configuration choices:**
  - **NextLS:** Enabled (`enable = true`) -- modern Elixir language server.
  - **ElixirLS:** Enabled with `dialyzerEnabled = false` (saves resources) and `enableTestLenses = false`.
  - **Projectionist:** Enabled for alternate file navigation.
  - Keymaps set on `on_attach` for Elixir-specific operations.
- **Keybindings (buffer-local, Elixir files only):**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>exp` | n | Convert from pipe syntax |
  | `<leader>exo` | n | Convert to pipe syntax |
  | `<leader>exm` | v | Expand macro |

---

### `ricardoramirezr/blade-nav.nvim`

- **GitHub:** [ricardoramirezr/blade-nav.nvim](https://github.com/ricardoramirezr/blade-nav.nvim)
- **Purpose:** Provides navigation and completion support for Laravel Blade templates, enabling goto-definition for components, includes, and other Blade directives.
- **Loading strategy:** Lazy-loaded on filetypes `blade` and `php`.
- **Dependencies:** `saghen/blink.cmp` (integrates as a blink.cmp completion source).
- **Key configuration choices:** None (default configuration). Registered as a blink.cmp provider in `completion.lua`.
- **Keybindings:** None.

---

## Media & Preview

### `3rd/image.nvim`

- **GitHub:** [3rd/image.nvim](https://github.com/3rd/image.nvim)
- **Purpose:** Displays images directly inside the Neovim terminal using the Kitty graphics protocol. Supports inline image rendering in markdown files and direct image file viewing.
- **Loading strategy:** Lazy-loaded on `VeryLazy`. Build is disabled (`build = false`).
- **Dependencies:** None (requires Kitty terminal and ImageMagick externally).
- **Key configuration choices:**
  - `backend = "kitty"` -- uses the Kitty terminal graphics protocol.
  - `processor = "magick_cli"` -- uses the ImageMagick CLI for image processing.
  - Hijacks file patterns: `*.png`, `*.jpg`, `*.jpeg`, `*.gif`, `*.webp`, `*.avif`, `*.svg`.
  - `max_height_window_percentage = 50` -- images take at most half the window height.
  - `window_overlap_clear_enabled = true` -- clears images when windows overlap.
  - Markdown integration enabled with remote image downloading.
  - Custom SVG support: intercepts `*.svg` / `*.svgz` files via `BufReadCmd`, converts to PNG using ImageMagick at 300 DPI with transparent background, and displays the result. Temporary PNG files are cleaned up on buffer close.
- **Keybindings:** None.

---

### `iamcco/markdown-preview.nvim`

- **GitHub:** [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- **Purpose:** Live markdown preview in the browser. Opens a local web server that renders markdown with live reload as you edit.
- **Loading strategy:** Lazy-loaded on filetype `markdown` and commands `MarkdownPreviewToggle`, `MarkdownPreview`, `MarkdownPreviewStop`. Builds with `cd app && npm install`.
- **Dependencies:** None (requires Node.js externally).
- **Key configuration choices:** Default configuration.
- **Keybindings:**

  | Key | Mode | Description |
  |-----|------|-------------|
  | `<leader>mp` | n | Toggle markdown preview |

---

## Notes on Common Patterns

### Italic Suppression

All five colorschemes in this configuration disable italic styling. This is a deliberate design choice for consistency:
- tokyonight: uses custom `on_highlights` (comments set to orange, not italic)
- catppuccin: `no_italic = true`
- rose-pine: `disable_italics = true`
- kanagawa: `commentStyle = { italic = false }`, `keywordStyle = { italic = false }`
- everforest: `everforest_disable_italic_comment = 1`

### Theme Persistence

The colorscheme system saves the active theme to `~/.local/share/nvim/theme.txt` and restores it on startup. The `<leader>tt` mapping opens a Telescope picker with live preview, and the selected theme is persisted automatically.

### Nerd Font Awareness

Several plugins check `vim.g.nerd_font` to conditionally enable icon support:
- `nvim-web-devicons` is only enabled when the flag is set
- `which-key.nvim` uses icon mappings conditionally
- `mini.statusline` uses icons conditionally

### LSP Formatting Fallback Strategy

The configuration uses a layered approach:
1. `conform.nvim` runs the configured external formatter first
2. If no formatter is configured or it fails, LSP formatting is used as fallback
3. C/C++ files are excluded from LSP formatting (only `clang-format` via conform)
4. Format-on-save runs on `BufWritePre` with a 500ms timeout

### Completion Source Priority

blink.cmp sources are ordered: `lsp` > `snippets` > `path` > `buffer`. For Lua files, `lazydev` is added with `score_offset = 100` to ensure Neovim API completions rank highest. For Blade/PHP files, `blade-nav` provides Blade-specific completions.
