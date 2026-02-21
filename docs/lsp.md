# LSP, Completion, Formatting, and Linting Configuration

This document covers the full language tooling pipeline in this Neovim configuration: how
language servers are installed and configured, how completion works, how files are formatted
on save, and how linting runs in the background.

---

## Table of Contents

1. [Overview](#overview)
2. [Mason -- Tool Installation](#mason----tool-installation)
3. [Configured Language Servers](#configured-language-servers)
4. [Per-Language LSP Settings (after/lsp/)](#per-language-lsp-settings-afterlsp)
5. [LSP Keybindings](#lsp-keybindings)
6. [LSP Features](#lsp-features)
7. [Completion (blink.cmp)](#completion-blinkcmp)
8. [Formatting (conform.nvim)](#formatting-conformnvim)
9. [Linting (nvim-lint)](#linting-nvim-lint)
10. [Adding a New Language Server](#adding-a-new-language-server)

---

## Overview

The language tooling pipeline is composed of four layers, each handled by a dedicated
plugin:

```
mason.nvim              -- installs LSP servers, formatters, and linters as local binaries
mason-lspconfig.nvim    -- bridges Mason-installed servers to nvim-lspconfig
mason-tool-installer    -- declarative list of tools that Mason must keep installed
nvim-lspconfig          -- configures and launches LSP servers per buffer
```

The entry point is `lua/plugins/lsp.lua`. It is loaded lazily on `BufReadPre` and
`BufNewFile`, meaning the entire LSP stack initializes the first time you open a real file.

**Capability broadcasting**: Before any server starts, `blink.cmp` capabilities are fetched
via `require("blink.cmp").get_lsp_capabilities()` and applied globally with
`vim.lsp.config("*", { capabilities = capabilities })`. This ensures every LSP server knows
the client supports the extended completion features that blink.cmp provides.

**Per-server configuration**: Individual server settings live in `after/lsp/<server>.lua`
files. Neovim's native `after/lsp/` directory convention is used: each file returns a table
that is merged into the server's configuration automatically when that server starts. No
explicit `lspconfig[server].setup()` calls are needed for servers that Mason enables
automatically.

**Exclusions from automatic enable**: The following servers are excluded from
`mason-lspconfig`'s `automatic_enable` because they use their own plugin or are not desired:
`rust_analyzer` (managed by rustaceanvim), `rescriptls`, and `stylua_lsp`.

---

## Mason -- Tool Installation

[Mason](https://github.com/williamboman/mason.nvim) is a portable package manager that
installs LSP servers, formatters, linters, and DAP adapters into a local directory
(`~/.local/share/nvim/mason/` by default).

### Configuration

Mason itself is set up with default options (`config = true`) and is loaded lazily via the
`:Mason` and `:MasonInstall` commands.

### Declarative ensure_installed list

`mason-tool-installer` keeps a declarative list of tools that must be installed. If any tool
is missing, it is installed automatically the next time Neovim starts.

**LSP Servers:**

| Mason package name              | LSP server it provides |
|---------------------------------|------------------------|
| `lua-language-server`           | lua_ls                 |
| `gopls`                         | gopls                  |
| `pyright`                       | pyright                |
| `typescript-language-server`    | ts_ls                  |
| `deno`                          | denols                 |
| `clangd`                        | clangd                 |
| `tailwindcss-language-server`   | tailwindcss            |
| `eslint-lsp`                    | eslint                 |
| `phpactor`                      | phpactor               |

**Formatters:**

| Mason package name | Formatter binary |
|--------------------|------------------|
| `stylua`           | stylua           |
| `clang-format`     | clang-format     |
| `prettierd`        | prettierd        |

**Linters:**

| Mason package name | Linter binary  |
|--------------------|----------------|
| `ruff`             | ruff           |
| `golangci-lint`    | golangcilint   |

### Using the Mason UI

Run `:Mason` to open the Mason UI. From there you can:

- See all installed tools and their versions.
- Search for and install new tools.
- Update tools to their latest versions.
- Uninstall tools you no longer need.

Run `:MasonInstall <package>` to install a specific tool from the command line without
opening the UI.

---

## Configured Language Servers

The table below lists every language server that this configuration supports. Servers are
configured either through Mason auto-enable (which reads `after/lsp/<server>.lua`) or
through a dedicated plugin.

| Server                              | Language(s)        | Root Markers                          | Special Settings                                                        | Setup Method         |
|-------------------------------------|--------------------|---------------------------------------|-------------------------------------------------------------------------|----------------------|
| `lua_ls`                            | Lua                | (default)                             | `callSnippet = "Replace"` -- replaces trigger text with snippet body    | Mason + after/lsp    |
| `gopls`                             | Go                 | (default)                             | `gofumpt = true`, `unusedparams = true`, `staticcheck = true`           | Mason + after/lsp    |
| `pyright`                           | Python             | (default)                             | None (empty config)                                                     | Mason + after/lsp    |
| `ts_ls`                             | TypeScript / JS    | `package.json`, `tsconfig.json`       | `single_file_support = false` -- only starts in Node/TS projects        | Mason + after/lsp    |
| `denols`                            | Deno TS / JS       | `deno.json`, `deno.jsonc`             | `single_file_support = false` -- only starts in Deno projects           | Mason + after/lsp    |
| `clangd`                            | C / C++            | (default)                             | `--offset-encoding=utf-16` passed as a cmd flag                         | Mason + after/lsp    |
| `tailwindcss`                       | CSS / HTML / JSX   | (default)                             | None (Mason defaults)                                                   | Mason auto-enable    |
| `eslint`                            | JS / TS            | (default)                             | None (Mason defaults)                                                   | Mason auto-enable    |
| `phpactor`                          | PHP                | (default)                             | None (empty config)                                                     | Mason + after/lsp    |
| `rust_analyzer`                     | Rust               | (default via rustaceanvim)            | Managed entirely by `rustaceanvim` (v8); excluded from mason auto-enable | rustaceanvim plugin  |
| `elixirls`                          | Elixir             | (default via elixir-tools)            | `dialyzerEnabled = false`, `enableTestLenses = false`                   | elixir-tools plugin  |
| `nextls`                            | Elixir (Next LS)   | (default via elixir-tools)            | Enabled alongside elixirls                                              | elixir-tools plugin  |
| `gleam`                             | Gleam              | (default)                             | None (empty config)                                                     | after/lsp            |
| `svelte`                            | Svelte             | (default)                             | None (empty config)                                                     | after/lsp            |
| `solidity_ls_nomicfoundation`       | Solidity           | `foundry.toml`, `.git`                | Custom cmd: `nomicfoundation-solidity-language-server --stdio`, `single_file_support = true` | after/lsp |

### ts_ls vs denols conflict resolution

Both `ts_ls` and `denols` serve TypeScript/JavaScript, but they target different runtimes.
The configuration avoids conflicts by using **root markers** with `single_file_support = false`:

- `ts_ls` only activates when `package.json` or `tsconfig.json` is found in the project root.
- `denols` only activates when `deno.json` or `deno.jsonc` is found in the project root.

Since `single_file_support` is `false` for both, neither server will start for a lone `.ts`
file that is not inside a recognized project.

---

## Per-Language LSP Settings (after/lsp/)

Each file in `after/lsp/` returns a Lua table that Neovim merges into the corresponding
server's configuration. Below is what each file configures.

### `after/lsp/lua_ls.lua`

```lua
return {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
        },
    },
}
```

Sets the completion call-snippet behavior to `"Replace"`. When completing a function call,
the trigger text is replaced with the full snippet (including parameter placeholders) rather
than merely inserting it.

### `after/lsp/gopls.lua`

```lua
return {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}
```

- **gofumpt**: Uses `gofumpt` (a stricter `gofmt`) for formatting.
- **unusedparams**: Flags function parameters that are declared but never used.
- **staticcheck**: Enables the full suite of `staticcheck` analyzers inside gopls.

### `after/lsp/ts_ls.lua`

```lua
return {
    root_markers = { "package.json", "tsconfig.json" },
    single_file_support = false,
}
```

Restricts ts_ls to projects containing `package.json` or `tsconfig.json`. Prevents it from
activating in Deno projects or on standalone files.

### `after/lsp/clangd.lua`

```lua
return {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
    },
}
```

Overrides the clangd command to pass `--offset-encoding=utf-16`. This resolves encoding
mismatches that can cause incorrect character positioning in diagnostics and code actions
when other plugins assume UTF-16 offsets.

### `after/lsp/denols.lua`

```lua
return {
    root_markers = { "deno.json", "deno.jsonc" },
    single_file_support = false,
}
```

Restricts denols to projects containing `deno.json` or `deno.jsonc`. Prevents it from
activating in Node.js projects or on standalone files.

### `after/lsp/solidity.lua`

```lua
return {
    cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
    filetypes = { "solidity" },
    root_markers = { "foundry.toml", ".git" },
    single_file_support = true,
}
```

Configures the Nomic Foundation Solidity language server for Hardhat/Foundry projects. Uses
`foundry.toml` as a root marker (alongside `.git` as a fallback) and enables single-file
support so the server works even outside a recognized project.

### `after/lsp/pyright.lua`

```lua
return {}
```

Empty configuration. Pyright uses all default settings. The file exists as a placeholder so
the server is recognized in the `after/lsp/` directory.

### `after/lsp/phpactor.lua`

```lua
return {}
```

Empty configuration. Phpactor uses all default settings.

### `after/lsp/svelte.lua`

```lua
return {}
```

Empty configuration. The Svelte language server uses all default settings.

### `after/lsp/gleam.lua`

```lua
return {}
```

Empty configuration. The Gleam language server uses all default settings. Note that Gleam's
LSP server ships with the Gleam compiler itself, so it does not need to be installed via
Mason.

---

## LSP Keybindings

All keybindings below are set in the `LspAttach` autocmd and are **buffer-local** -- they
only exist in buffers where an LSP server has attached. They are all prefixed with
`LSP: ` in their description for which-key discovery.

| Keymap          | Mode(s) | Action                                         | Description             |
|-----------------|---------|------------------------------------------------|-------------------------|
| `gd`            | n       | `telescope.builtin.lsp_definitions`            | Goto Definition         |
| `gr`            | n       | `telescope.builtin.lsp_references`             | Goto References         |
| `gI`            | n       | `telescope.builtin.lsp_implementations`        | Goto Implementation     |
| `<leader>D`     | n       | `telescope.builtin.lsp_type_definitions`       | Type Definition         |
| `<leader>ds`    | n       | `telescope.builtin.lsp_document_symbols`       | Document Symbols        |
| `<leader>ws`    | n       | `telescope.builtin.lsp_dynamic_workspace_symbols` | Workspace Symbols    |
| `<leader>rn`    | n       | `vim.lsp.buf.rename`                           | Rename symbol           |
| `<leader>ca`    | n, x    | `vim.lsp.buf.code_action`                      | Code Action             |
| `gD`            | n       | `vim.lsp.buf.declaration`                      | Goto Declaration        |
| `<leader>th`    | n       | Toggle `vim.lsp.inlay_hint`                    | Toggle Inlay Hints      |

Notes:
- `gd`, `gr`, `gI`, `<leader>D`, `<leader>ds`, and `<leader>ws` all open results in
  Telescope, giving you fuzzy-find and preview capabilities.
- `<leader>ca` works in both normal and visual mode, allowing you to apply code actions to
  a selected range.
- `<leader>th` only appears if the attached server supports `textDocument/inlayHint`.

### Elixir-specific keybindings

These are set in the `elixir-tools` plugin's `on_attach` and are buffer-local to Elixir
files:

| Keymap          | Mode | Action                  | Description              |
|-----------------|------|-------------------------|--------------------------|
| `<leader>exp`   | n    | `:ElixirFromPipe`       | Convert from pipe syntax |
| `<leader>exo`   | n    | `:ElixirToPipe`         | Convert to pipe syntax   |
| `<leader>exm`   | v    | `:ElixirExpandMacro`    | Expand macro             |

---

## LSP Features

### Document Highlight

When the cursor rests on a symbol (`CursorHold` / `CursorHoldI`), the LSP server is asked
to highlight all references to that symbol in the current buffer. Highlights are cleared on
`CursorMoved` / `CursorMovedI`. This feature only activates if the attached server supports
`textDocument/documentHighlight`.

A corresponding `LspDetach` autocmd cleans up highlights and removes the autocmds when a
server detaches from a buffer.

### Inlay Hints

Inlay hints (type annotations, parameter names, etc.) can be toggled on and off with
`<leader>th`. The toggle applies globally to the current buffer via
`vim.lsp.inlay_hint.enable()`. This keymap only appears if the server advertises
`textDocument/inlayHint` support.

### blink.cmp Capability Integration

At startup, `require("blink.cmp").get_lsp_capabilities()` is called and the result is
applied to all servers via `vim.lsp.config("*", { capabilities = capabilities })`. This
advertises to every LSP server that the client supports:

- Extended completion item kinds
- Snippet support
- Resolve support for additional completion item fields
- Label details
- Other blink.cmp-specific capabilities

This is done once, globally, before any server starts.

### lazydev.nvim (Lua development)

The `lazydev.nvim` plugin is loaded as a dependency and is active only for `lua` filetypes.
It provides:

- Completion and type information for the Neovim Lua API (`vim.*`).
- The `luvit-meta` library is included for `vim.uv` type annotations.
- It integrates with blink.cmp as a custom source (see Completion section).

---

## Completion (blink.cmp)

Completion is powered by [blink.cmp](https://github.com/Saghen/blink.cmp) (version 1.*),
loaded lazily on `InsertEnter`.

### Architecture

blink.cmp is a high-performance completion engine written in Rust. It gathers candidates
from multiple **sources**, ranks them, and presents them in a floating menu. Snippet
expansion is delegated to [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (version 2.*) via
the `snippets = { preset = "luasnip" }` setting.

LuaSnip is built with `make install_jsregexp` on systems that have `make` available (skipped
on Windows or when `make` is not found).

### Sources

**Default sources** (active in all filetypes unless overridden):

| Source      | Description                              | Priority |
|-------------|------------------------------------------|----------|
| `lsp`       | Completions from the attached LSP server | default  |
| `snippets`  | Snippet completions via LuaSnip          | default  |
| `path`      | File path completions                    | default  |
| `buffer`    | Words from the current buffer            | default  |

**Per-filetype source overrides:**

| Filetype | Extra Sources  | Inherits Defaults? | Provider Details                                      |
|----------|----------------|--------------------|-------------------------------------------------------|
| `lua`    | `lazydev`      | Yes                | `lazydev.integrations.blink`, score_offset = 100 (highest priority) |
| `blade`  | `blade-nav`    | Yes                | `blade-nav.blink` -- Laravel Blade navigation         |
| `php`    | `blade-nav`    | Yes                | `blade-nav.blink` -- Laravel Blade navigation         |

The `lazydev` source has a `score_offset` of 100, which means Neovim API completions are
prioritized above all other sources when editing Lua files.

### Keymaps

The keymap preset is `"none"` (no defaults), and all bindings are explicitly defined:

| Keymap       | Action                    | Description                            |
|--------------|---------------------------|----------------------------------------|
| `<C-n>`      | `select_next`             | Select next completion item            |
| `<C-p>`      | `select_prev`             | Select previous completion item        |
| `<Down>`     | `select_next`             | Select next completion item            |
| `<Up>`       | `select_prev`             | Select previous completion item        |
| `<C-b>`      | `scroll_documentation_up` | Scroll documentation window up         |
| `<C-f>`      | `scroll_documentation_down`| Scroll documentation window down      |
| `<Tab>`      | `select_and_accept`       | Accept the selected completion         |
| `<C-y>`      | `select_and_accept`       | Accept the selected completion         |
| `<C-Space>`  | `show`                    | Manually trigger completion menu       |
| `<C-e>`      | `hide`                    | Dismiss the completion menu            |
| `<C-l>`      | `snippet_forward`         | Jump to next snippet placeholder       |
| `<C-h>`      | `snippet_backward`        | Jump to previous snippet placeholder   |

All keymaps have a `"fallback"` action, meaning if blink.cmp does not handle the key (e.g.,
no menu is open), the key is passed through to its normal behavior.

### Other Settings

- **Auto-brackets**: Enabled (`completion.accept.auto_brackets.enabled = true`). When you
  accept a function completion, matching parentheses are inserted automatically.
- **Auto-show documentation**: Enabled (`completion.documentation.auto_show = true`). The
  documentation window appears automatically when you highlight a completion item.

---

## Formatting (conform.nvim)

Formatting is handled by [conform.nvim](https://github.com/stevearc/conform.nvim), loaded
lazily on `BufWritePre` and via the `:ConformInfo` command.

### Formatters by Filetype

| Filetype       | Formatters                                   | Behavior                              |
|----------------|----------------------------------------------|---------------------------------------|
| `lua`          | `stylua`                                     | Single formatter                      |
| `c++`          | `clang-format`                               | Single formatter                      |
| `cpp`          | `clang-format`                               | Single formatter                      |
| `javascript`   | `prettierd`, `prettier`                      | `stop_after_first = true` -- uses prettierd if available, falls back to prettier |
| `typescript`   | `prettierd`, `prettier`                      | `stop_after_first = true` -- uses prettierd if available, falls back to prettier |
| `php`          | `pint`, `php_cs_fixer`                       | `stop_after_first = true` -- uses pint if available, falls back to php_cs_fixer |

For filetypes not listed above, conform.nvim defers to the LSP server for formatting (via
`lsp_format = "fallback"`).

### Format on Save

Format-on-save is enabled for all filetypes with a timeout of 500ms. The behavior varies:

- **C and C++ (`c`, `cpp`)**: `lsp_format` is set to `"never"`. This means only
  `clang-format` (the conform formatter) runs; the clangd LSP formatter is never invoked.
  This avoids double-formatting or conflicts between clangd and clang-format.
- **All other filetypes**: `lsp_format` is set to `"fallback"`. Conform formatters run
  first; if none are configured for the filetype, the LSP server's formatter is used as a
  fallback.

Error notifications are suppressed (`notify_on_error = false`).

### Manual Format

Press `<leader>f` in any mode to manually format the current buffer. Manual formatting uses
`async = true` (non-blocking) with `lsp_format = "fallback"`.

---

## Linting (nvim-lint)

Linting is handled by [nvim-lint](https://github.com/mfussenegger/nvim-lint), loaded on
`BufReadPre` and `BufNewFile`.

### Linters by Filetype

| Filetype | Linter(s)      | Notes                                  |
|----------|----------------|----------------------------------------|
| `python` | `ruff`         | Fast Python linter / formatter         |
| `go`     | `golangcilint` | Runs multiple Go linters in parallel   |

### Auto-trigger Events

Linting runs automatically on the following events:

| Event           | When it fires                                    |
|-----------------|--------------------------------------------------|
| `BufWritePost`  | After writing the buffer to disk                 |
| `InsertLeave`   | After leaving insert mode                        |
| `BufReadPost`   | After reading a buffer from disk (initial open)  |

The autocmd checks `vim.bo.buftype == ""` before linting, ensuring that special buffers
(help, terminal, quickfix, etc.) are not linted.

All linting autocmds are grouped under the `nvim-lint` augroup.

---

## Adding a New Language Server

Follow these steps to add support for a new language.

### Step 1: Add the Mason package

In `lua/plugins/lsp.lua`, add the Mason package name to the `ensure_installed` list inside
the `mason-tool-installer` setup:

```lua
require("mason-tool-installer").setup({
    ensure_installed = {
        -- ... existing entries ...
        "your-language-server",   -- <-- add here
    },
})
```

Use the Mason package name (run `:Mason` and search for your server to find the correct
name).

### Step 2: Create an after/lsp config (if needed)

If your server needs custom settings (root markers, settings, cmd overrides), create a file
at `after/lsp/<server_name>.lua` where `<server_name>` matches the lspconfig server name
(not the Mason package name):

```lua
-- after/lsp/your_server.lua
return {
    root_markers = { "your_config.json", ".git" },
    settings = {
        yourServer = {
            someOption = true,
        },
    },
}
```

If no custom settings are needed, you can create an empty config file or omit it entirely --
Mason auto-enable will use default settings.

### Step 3: Exclude from auto-enable (if needed)

If the server is managed by a dedicated plugin (like `rustaceanvim` for Rust), add it to the
`automatic_enable.exclude` list in the `mason-lspconfig` setup:

```lua
require("mason-lspconfig").setup({
    automatic_enable = {
        exclude = { "rust_analyzer", "rescriptls", "stylua_lsp", "your_server" },
    },
})
```

### Step 4: Add formatters (if needed)

In `lua/plugins/formatting.lua`, add the formatter to `formatters_by_ft`:

```lua
formatters_by_ft = {
    -- ... existing entries ...
    your_language = { "your-formatter" },
}
```

If the formatter needs to be installed via Mason, also add it to `ensure_installed` in
`lua/plugins/lsp.lua`.

### Step 5: Add linters (if needed)

In `lua/plugins/linting.lua`, add the linter to `linters_by_ft`:

```lua
lint.linters_by_ft = {
    -- ... existing entries ...
    your_language = { "your-linter" },
}
```

If the linter needs to be installed via Mason, also add it to `ensure_installed` in
`lua/plugins/lsp.lua`.

---

## File Reference

| File                              | Purpose                                              |
|-----------------------------------|------------------------------------------------------|
| `lua/plugins/lsp.lua`            | Core LSP setup: Mason, keymaps, capabilities, tool list |
| `lua/plugins/completion.lua`     | blink.cmp completion engine configuration            |
| `lua/plugins/formatting.lua`     | conform.nvim formatter configuration                 |
| `lua/plugins/linting.lua`        | nvim-lint linter configuration                       |
| `lua/plugins/lang-rust.lua`      | rustaceanvim setup for Rust (manages rust_analyzer)  |
| `lua/plugins/lang-elixir.lua`    | elixir-tools setup for Elixir (elixirls + nextls)    |
| `after/lsp/lua_ls.lua`           | Lua LS settings (snippet replacement)                |
| `after/lsp/gopls.lua`            | gopls settings (gofumpt, staticcheck, unusedparams)  |
| `after/lsp/ts_ls.lua`            | TypeScript LS root markers and single-file policy    |
| `after/lsp/denols.lua`           | Deno LS root markers and single-file policy          |
| `after/lsp/clangd.lua`           | clangd UTF-16 offset encoding flag                   |
| `after/lsp/pyright.lua`          | Pyright defaults (empty)                             |
| `after/lsp/phpactor.lua`         | Phpactor defaults (empty)                            |
| `after/lsp/svelte.lua`           | Svelte LS defaults (empty)                           |
| `after/lsp/gleam.lua`            | Gleam LS defaults (empty)                            |
| `after/lsp/solidity.lua`         | Solidity LS (Nomic Foundation, Foundry root markers) |
