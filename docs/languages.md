# Language-Specific Configurations

This document covers every language supported by this Neovim configuration, including LSP servers, Treesitter parsers, formatters, linters, special plugins, keybindings, and project-detection root markers.

---

## Table of Contents

1. [Lua](#lua)
2. [Go](#go)
3. [Python](#python)
4. [TypeScript / JavaScript](#typescript--javascript)
5. [Deno](#deno)
6. [C / C++](#c--c)
7. [Rust](#rust)
8. [Elixir](#elixir)
9. [PHP](#php)
10. [Svelte](#svelte)
11. [Gleam](#gleam)
12. [Solidity](#solidity)
13. [HTML / CSS (Tailwind)](#html--css-tailwind)
14. [Markdown](#markdown)
15. [Treesitter Parsers (Full List)](#treesitter-parsers-full-list)
16. [TypeScript vs Deno -- Avoiding Conflicts](#typescript-vs-deno----avoiding-conflicts)
17. [Adding a New Language](#adding-a-new-language)

---

## Lua

### LSP Server

- **lua_ls** (lua-language-server), installed via Mason.
- Configuration file: `after/lsp/lua_ls.lua`
- Settings:
  - `Lua.completion.callSnippet = "Replace"` -- when completing a function call, the snippet replaces the word under the cursor rather than inserting next to it.

```lua
-- after/lsp/lua_ls.lua
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

### Treesitter Parsers

- `lua`
- `luadoc`

### Formatter

- **stylua** -- configured in `conform.nvim` and installed via Mason.
- Runs on save with LSP fallback.

```lua
-- formatters_by_ft (from formatting.lua)
lua = { "stylua" },
```

### Linter

- None configured explicitly. lua_ls provides diagnostics.

### Special Plugins

- **lazydev.nvim** (`folke/lazydev.nvim`) -- loaded only for `ft = "lua"`. Provides completion and type information for the Neovim Lua API, `vim.uv`, and the luvit library.
- **luvit-meta** (`Bilal2453/luvit-meta`) -- lazy-loaded type stubs consumed by lazydev.

### Root Markers

- Default lua_ls detection (no custom root markers configured).

---

## Go

### LSP Server

- **gopls**, installed via Mason.
- Configuration file: `after/lsp/gopls.lua`
- Settings:
  - `analyses.unusedparams = true` -- flags unused function parameters.
  - `staticcheck = true` -- enables the staticcheck analyzer for additional diagnostics.
  - `gofumpt = true` -- uses gofumpt (a stricter gofmt) for formatting.

```lua
-- after/lsp/gopls.lua
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

### Treesitter Parser

- `go`

### Formatter

- None configured in conform.nvim. Formatting is handled by gopls itself (via `gofumpt = true`), which runs through the `lsp_format = "fallback"` path on save.

### Linter

- **golangci-lint** -- configured in `nvim-lint` and installed via Mason.
- Triggers on `BufWritePost`, `InsertLeave`, and `BufReadPost`.

```lua
-- linters_by_ft (from linting.lua)
go = { "golangcilint" },
```

### Root Markers

- Default gopls detection (go.mod, go.sum, .git).

---

## Python

### LSP Server

- **pyright**, installed via Mason.
- Configuration file: `after/lsp/pyright.lua` -- returns an empty table, meaning all defaults are used.

### Treesitter Parser

- `python`

### Formatter

- None configured in conform.nvim for Python. Formatting is delegated to the LSP fallback (pyright does not format, but ruff can act as both formatter and linter via its own integration).

### Linter

- **ruff** -- configured in `nvim-lint` and installed via Mason.
- Ruff provides both linting and formatting capabilities for Python.
- Triggers on `BufWritePost`, `InsertLeave`, and `BufReadPost`.

```lua
-- linters_by_ft (from linting.lua)
python = { "ruff" },
```

### Root Markers

- Default pyright detection (pyrightconfig.json, pyproject.toml, setup.py, .git).

---

## TypeScript / JavaScript

### LSP Servers

- **ts_ls** (typescript-language-server), installed via Mason.
  - Configuration file: `after/lsp/ts_ls.lua`
  - Root markers: `package.json`, `tsconfig.json`
  - `single_file_support = false` -- the server will NOT attach to standalone .ts/.js files that are not inside a project with one of the root markers. This is critical for coexistence with Deno (see [TypeScript vs Deno](#typescript-vs-deno----avoiding-conflicts)).

```lua
-- after/lsp/ts_ls.lua
return {
    root_markers = { "package.json", "tsconfig.json" },
    single_file_support = false,
}
```

- **eslint-lsp** -- installed via Mason. Provides ESLint diagnostics as an LSP server. No custom configuration file; uses defaults.

### Treesitter Parsers

- `javascript`
- `typescript`
- `json`

### Formatter

- **prettierd** (preferred) or **prettier** (fallback) -- configured in conform.nvim, installed via Mason.
- Uses `stop_after_first = true`, meaning if prettierd succeeds, prettier is not invoked.

```lua
-- formatters_by_ft (from formatting.lua)
javascript = { "prettierd", "prettier", stop_after_first = true },
typescript = { "prettierd", "prettier", stop_after_first = true },
```

### Linter

- ESLint diagnostics provided via eslint-lsp (LSP-based, not via nvim-lint).

### Root Markers

- `package.json`, `tsconfig.json` (for ts_ls).

---

## Deno

### LSP Server

- **denols**, installed via Mason.
- Configuration file: `after/lsp/denols.lua`
- Root markers: `deno.json`, `deno.jsonc`
- `single_file_support = false` -- denols will NOT attach unless one of the root markers is found.

```lua
-- after/lsp/denols.lua
return {
    root_markers = { "deno.json", "deno.jsonc" },
    single_file_support = false,
}
```

### Treesitter Parsers

- Uses the same `javascript` and `typescript` treesitter parsers as TypeScript/JavaScript.

### Formatter

- Deno has a built-in formatter (`deno fmt`). Formatting falls back to denols via LSP on save.

### Linter

- Deno has a built-in linter. Diagnostics are provided by denols.

### Root Markers

- `deno.json`, `deno.jsonc`

### Coexistence with TypeScript

See [TypeScript vs Deno](#typescript-vs-deno----avoiding-conflicts) for details on how the two servers avoid conflicts.

---

## C / C++

### LSP Server

- **clangd**, installed via Mason.
- Configuration file: `after/lsp/clangd.lua`
- Custom command: `clangd --offset-encoding=utf-16` -- overrides the default offset encoding to UTF-16 for compatibility with Neovim's LSP client.

```lua
-- after/lsp/clangd.lua
return {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
    },
}
```

### Treesitter Parsers

- `c`
- `cpp`

### Formatter

- **clang-format** -- configured in conform.nvim and installed via Mason.
- Applies to both `c++` and `cpp` filetypes.

```lua
-- formatters_by_ft (from formatting.lua)
["c++"] = { "clang-format" },
cpp = { "clang-format" },
```

### Linter

- None configured in nvim-lint. Diagnostics are provided by clangd.

### Format-on-Save Behavior

- **LSP formatting is disabled on save for C and C++ files.** The `format_on_save` function in `formatting.lua` checks the filetype and sets `lsp_format = "never"` for `c` and `cpp`. This means clangd will not auto-format on save; only manual formatting via `<leader>f` will invoke clang-format.

```lua
-- from formatting.lua
format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = "never"
    else
        lsp_format_opt = "fallback"
    end
    return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
    }
end,
```

### Root Markers

- Default clangd detection (compile_commands.json, .clangd, .git).

---

## Rust

### LSP Server

- **rust_analyzer** -- managed entirely by **rustaceanvim**, NOT by Mason.
- rust_analyzer is explicitly excluded from Mason's automatic LSP enabling:

```lua
-- from lsp.lua
require("mason-lspconfig").setup({
    automatic_enable = {
        exclude = { "rust_analyzer", "rescriptls", "stylua_lsp" },
    },
})
```

### Special Plugin

- **rustaceanvim** (`mrcjkb/rustaceanvim`) version `^8`.
- Loaded eagerly (`lazy = false`).
- Provides a complete Rust development experience: LSP management, debugging, inlay hints, runnables, and more.
- Automatically downloads and manages rust_analyzer.

```lua
-- lua/plugins/lang-rust.lua
return {
    "mrcjkb/rustaceanvim",
    version = "^8",
    lazy = false,
}
```

### Treesitter Parser

- `rust`

### Formatter

- Not configured in conform.nvim. Formatting is handled by rust_analyzer (rustfmt) via the LSP fallback on save.

### Linter

- Diagnostics provided by rust_analyzer (including clippy if configured in the project).

### Root Markers

- Default rust_analyzer detection (Cargo.toml, rust-project.json).

---

## Elixir

### LSP Servers

Managed by **elixir-tools.nvim** (`elixir-tools/elixir-tools.nvim`), NOT by Mason. Two language servers run simultaneously:

- **nextls** (Next LS) -- enabled with default settings.
- **elixirls** (ElixirLS) -- enabled with custom settings:
  - `dialyzerEnabled = false` -- Dialyzer is disabled to avoid slow startup and high memory usage.
  - `enableTestLenses = false` -- code lenses for running tests inline are disabled.

```lua
-- lua/plugins/lang-elixir.lua
elixir.setup({
    nextls = { enable = true },
    elixirls = {
        enable = true,
        settings = elixirls.settings({
            dialyzerEnabled = false,
            enableTestLenses = false,
        }),
        on_attach = function(_, _)
            -- keymaps set here (see below)
        end,
    },
    projectionist = { enable = true },
})
```

### Treesitter Parser

- `elixir`

### Formatter

- Not configured in conform.nvim. Formatting is handled by ElixirLS/NextLS via LSP fallback, which delegates to `mix format`.

### Linter

- Diagnostics provided by ElixirLS and NextLS.

### Special Keymaps

These keymaps are buffer-local and only active in Elixir files (set via `on_attach`):

| Keymap | Mode | Command | Description |
|--------|------|---------|-------------|
| `<leader>exp` | Normal | `:ElixirFromPipe` | Convert a pipe chain back to nested function calls |
| `<leader>exo` | Normal | `:ElixirToPipe` | Convert nested function calls into a pipe chain |
| `<leader>exm` | Visual | `:ElixirExpandMacro` | Expand the selected macro to see its generated code |

### Special Plugins

- **elixir-tools.nvim** (`elixir-tools/elixir-tools.nvim`) -- all-in-one Elixir plugin.
  - Depends on `nvim-lua/plenary.nvim`.
  - Loaded on `BufReadPre` and `BufNewFile`.
  - Includes **projectionist** support (`projectionist = { enable = true }`) for alternate file navigation.

### Root Markers

- Default ElixirLS/NextLS detection (mix.exs, .git).

---

## PHP

### LSP Server

- **phpactor**, installed via Mason.
- Configuration file: `after/lsp/phpactor.lua` -- returns an empty table, meaning all defaults are used.

### Treesitter Parser

- `php`

### Formatter

- **pint** (preferred) or **php_cs_fixer** (fallback) -- configured in conform.nvim.
- Uses `stop_after_first = true`.

```lua
-- formatters_by_ft (from formatting.lua)
php = { "pint", "php_cs_fixer", stop_after_first = true },
```

### Linter

- None configured in nvim-lint. Diagnostics provided by phpactor.

### Special Plugins

- **blade-nav.nvim** (`ricardoramirezr/blade-nav.nvim`) -- provides navigation support for Laravel Blade templates.
  - Loaded for `blade` and `php` filetypes.
  - Depends on `saghen/blink.cmp` for completion integration.

```lua
-- lua/plugins/lang-php.lua
return {
    "ricardoramirezr/blade-nav.nvim",
    dependencies = { "saghen/blink.cmp" },
    ft = { "blade", "php" },
}
```

### Blade Template Filetype Detection

A custom autocmd in `lua/core/autocmds.lua` detects `.blade.php` files and sets their filetype to `blade`:

```lua
-- lua/core/autocmds.lua
vim.api.nvim_create_augroup("BladeFiletypeRelated", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.blade.php",
    group = "BladeFiletypeRelated",
    callback = function()
        vim.bo.filetype = "blade"
    end,
})
```

Additionally, in `lua/plugins/treesitter.lua`, the blade filetype is registered with treesitter:

```lua
vim.treesitter.language.register("blade", "blade")
```

A compatibility shim is also provided for `blade-nav.nvim`, which relies on the removed `parsers.get_parser` API:

```lua
local parsers = require("nvim-treesitter.parsers")
if not parsers.get_parser then
    parsers.get_parser = function(bufnr, lang)
        return vim.treesitter.get_parser(bufnr, lang)
    end
end
```

### Root Markers

- Default phpactor detection (composer.json, .git).

---

## Svelte

### LSP Server

- **svelte** (svelte-language-server).
- Configuration file: `after/lsp/svelte.lua` -- returns an empty table, meaning all defaults are used.
- Note: svelte-language-server is NOT in the Mason `ensure_installed` list. It must be installed manually or will be auto-detected if available on `$PATH`.

### Treesitter Parser

- `svelte`

### Formatter

- Not configured in conform.nvim. Formatting falls back to the Svelte LSP.

### Linter

- Diagnostics provided by svelte-language-server.

### Root Markers

- Default svelte-language-server detection (svelte.config.js, .git).

---

## Gleam

### LSP Server

- **gleam** (Gleam's built-in language server).
- Configuration file: `after/lsp/gleam.lua` -- returns an empty table, meaning all defaults are used.
- Note: The Gleam LSP is bundled with the Gleam compiler itself. It is NOT in the Mason `ensure_installed` list; the `gleam` binary must be available on `$PATH`.

### Treesitter Parser

- Not in the `ensure_installed` list. Treesitter has `auto_install = true`, so the gleam parser will be installed automatically when a `.gleam` file is opened (if a gleam parser is available).

### Formatter

- Not configured in conform.nvim. Gleam has a built-in formatter (`gleam format`) accessed via LSP fallback.

### Linter

- Diagnostics provided by the Gleam LSP.

### Root Markers

- Default Gleam LSP detection (gleam.toml, .git).

---

## Solidity

### LSP Server

- **solidity_ls_nomicfoundation** (Nomic Foundation's Solidity language server for Hardhat/Foundry projects).
- Configuration file: `after/lsp/solidity.lua`
- Custom command: `nomicfoundation-solidity-language-server --stdio`
- Filetypes: `solidity`
- Root markers: `foundry.toml`, `.git`
- `single_file_support = true` -- will attach to standalone Solidity files.

```lua
-- after/lsp/solidity.lua
return {
    cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
    filetypes = { "solidity" },
    root_markers = { "foundry.toml", ".git" },
    single_file_support = true,
}
```

### Treesitter Parser

- Not in the `ensure_installed` list. Will be auto-installed if available due to `auto_install = true`.

### Formatter

- Not configured in conform.nvim. Formatting falls back to the Solidity LSP.

### Linter

- Diagnostics provided by the Solidity LSP.

### Root Markers

- `foundry.toml`, `.git`

---

## HTML / CSS (Tailwind)

### LSP Server

- **tailwindcss-language-server**, installed via Mason.
- No custom configuration file in `after/lsp/`.
- Provides Tailwind CSS class completions, hover previews, and diagnostics for HTML, JSX, TSX, Svelte, and other template files.

### Treesitter Parsers

- `html`
- `css`

### Formatter

- Not configured explicitly. HTML/CSS formatting falls back to LSP or can be handled by prettierd/prettier if configured for those filetypes.

### Linter

- Diagnostics provided by tailwindcss-language-server (class conflicts, unknown utilities).

---

## Markdown

### LSP Server

- None configured specifically for Markdown.

### Treesitter Parsers

- `markdown`
- `markdown_inline`

### Special Plugins

- **markdown-preview.nvim** -- provides live Markdown preview in the browser.
  - Keymap: `<leader>mp` to toggle the Markdown preview.

### Formatter

- Not configured in conform.nvim for Markdown.

### Linter

- None configured.

---

## Treesitter Parsers (Full List)

The following parsers are in the `ensure_installed` list and will be downloaded automatically. Treesitter also has `auto_install = true`, so any language not listed here will have its parser installed on first use if one is available.

| Parser | Language |
|--------|----------|
| `bash` | Bash / Shell |
| `c` | C |
| `cpp` | C++ |
| `css` | CSS |
| `diff` | Diff / Patch |
| `elixir` | Elixir |
| `go` | Go |
| `html` | HTML |
| `javascript` | JavaScript |
| `json` | JSON |
| `lua` | Lua |
| `luadoc` | Lua documentation comments |
| `markdown` | Markdown |
| `markdown_inline` | Markdown inline elements |
| `php` | PHP |
| `python` | Python |
| `query` | Treesitter query language |
| `rust` | Rust |
| `svelte` | Svelte |
| `typescript` | TypeScript |
| `vim` | Vimscript |
| `vimdoc` | Vim help files |

Additionally, the `blade` filetype is registered with treesitter for Laravel Blade template support:

```lua
vim.treesitter.language.register("blade", "blade")
```

### Treesitter Textobjects

The `nvim-treesitter-textobjects` plugin provides structural selection, movement, and swapping:

**Selection (Visual/Operator-pending mode):**

| Keymap | Textobject |
|--------|------------|
| `af` / `if` | Function (outer / inner) |
| `ac` / `ic` | Class (outer / inner) |
| `aa` / `ia` | Parameter/Argument (outer / inner) |
| `al` / `il` | Loop (outer / inner) |

**Movement (Normal/Visual/Operator-pending mode):**

| Keymap | Description |
|--------|-------------|
| `]f` / `[f` | Next / Previous function start |
| `]c` / `[c` | Next / Previous class start |
| `]a` / `[a` | Next / Previous argument |

**Swapping (Normal mode):**

| Keymap | Description |
|--------|-------------|
| `<leader>xa` | Swap current parameter with the next one |
| `<leader>xA` | Swap current parameter with the previous one |

---

## TypeScript vs Deno -- Avoiding Conflicts

Both TypeScript/JavaScript and Deno use the same file extensions (`.ts`, `.js`, `.tsx`, `.jsx`), which means two LSP servers could attach to the same buffer and produce conflicting diagnostics, completions, and formatting. This configuration avoids that problem through **root markers** and **disabled single-file support**.

### How It Works

1. **ts_ls** only activates when it finds `package.json` or `tsconfig.json` in the project root:
   ```lua
   -- after/lsp/ts_ls.lua
   return {
       root_markers = { "package.json", "tsconfig.json" },
       single_file_support = false,
   }
   ```

2. **denols** only activates when it finds `deno.json` or `deno.jsonc` in the project root:
   ```lua
   -- after/lsp/denols.lua
   return {
       root_markers = { "deno.json", "deno.jsonc" },
       single_file_support = false,
   }
   ```

3. Both servers have `single_file_support = false`, meaning neither will attach to a loose `.ts` or `.js` file that is not inside a recognized project.

### Practical Effect

| Project type | Root file present | LSP attached |
|---|---|---|
| Node.js / npm project | `package.json` | ts_ls |
| TypeScript project | `tsconfig.json` | ts_ls |
| Deno project | `deno.json` | denols |
| Standalone `.ts` file (no project) | None | Neither (no LSP) |

### Important Notes

- A project should never contain both `package.json` and `deno.json` at the same root level. If it does, both servers will attach and conflict.
- If you need LSP for standalone TypeScript/JavaScript files, you must create a minimal `tsconfig.json` or `package.json` in the directory.

---

## Adding a New Language

Follow these steps to add full support for a new language.

### Step 1: Install the Treesitter Parser

Edit `lua/plugins/treesitter.lua` and add the parser name to the `ensure_installed` list:

```lua
ensure_installed = {
    -- ... existing parsers ...
    "your_language",
},
```

Alternatively, since `auto_install = true` is set, simply opening a file of that language will auto-install the parser if one exists.

### Step 2: Add the LSP Server to Mason

Edit `lua/plugins/lsp.lua` and add the server to the `ensure_installed` list inside `mason-tool-installer`:

```lua
require("mason-tool-installer").setup({
    ensure_installed = {
        -- ... existing servers ...
        "your-language-server",
    },
})
```

Find the correct Mason package name by running `:Mason` and searching for your language server.

### Step 3: Create the LSP Configuration File

Create a new file at `after/lsp/<server_name>.lua` that returns a configuration table. The filename must match the LSP server name exactly as registered with `nvim-lspconfig`.

Minimal example (no custom settings):

```lua
-- after/lsp/your_server.lua
return {}
```

Example with custom settings:

```lua
-- after/lsp/your_server.lua
return {
    root_markers = { "your_project_file.toml", ".git" },
    settings = {
        yourServer = {
            someOption = true,
        },
    },
}
```

Mason-lspconfig's `automatic_enable` will automatically start the server for the correct filetypes. If the server should NOT be auto-enabled by Mason (e.g., it is managed by a dedicated plugin like rustaceanvim), add it to the exclude list:

```lua
require("mason-lspconfig").setup({
    automatic_enable = {
        exclude = { "your_server" },
    },
})
```

### Step 4: Add a Formatter (Optional)

Edit `lua/plugins/formatting.lua` and add an entry to `formatters_by_ft`:

```lua
formatters_by_ft = {
    -- ... existing formatters ...
    your_language = { "your_formatter" },
},
```

If the formatter needs to be installed via Mason, also add it to the `ensure_installed` list in `lua/plugins/lsp.lua`.

If you want to disable LSP formatting on save for this filetype (like C/C++), add it to the `disable_filetypes` table in the `format_on_save` function:

```lua
local disable_filetypes = { c = true, cpp = true, your_language = true }
```

### Step 5: Add a Linter (Optional)

Edit `lua/plugins/linting.lua` and add an entry to `linters_by_ft`:

```lua
lint.linters_by_ft = {
    -- ... existing linters ...
    your_language = { "your_linter" },
}
```

If the linter needs to be installed via Mason, also add it to the `ensure_installed` list in `lua/plugins/lsp.lua`.

### Step 6: Add a Dedicated Plugin (Optional)

If the language benefits from a specialized plugin (like `rustaceanvim` for Rust or `elixir-tools.nvim` for Elixir), create a new plugin file at `lua/plugins/lang-<language>.lua`:

```lua
-- lua/plugins/lang-your_language.lua
return {
    "author/your-language-plugin.nvim",
    ft = { "your_language" },
    config = function()
        -- plugin setup
    end,
}
```

### Summary Checklist

| Step | File to Edit/Create | Required? |
|------|---------------------|-----------|
| Treesitter parser | `lua/plugins/treesitter.lua` | Recommended |
| Mason install | `lua/plugins/lsp.lua` (ensure_installed) | Yes (unless externally managed) |
| LSP config | `after/lsp/<server>.lua` | Yes |
| Formatter | `lua/plugins/formatting.lua` | Optional |
| Linter | `lua/plugins/linting.lua` | Optional |
| Dedicated plugin | `lua/plugins/lang-<language>.lua` | Optional |

---

## Global LSP Keymaps

These keybindings are available in any buffer where an LSP server is attached (defined in `lua/plugins/lsp.lua` via the `LspAttach` autocmd):

| Keymap | Mode | Description |
|--------|------|-------------|
| `gd` | Normal | Go to definition (via Telescope) |
| `gr` | Normal | Go to references (via Telescope) |
| `gI` | Normal | Go to implementation (via Telescope) |
| `gD` | Normal | Go to declaration |
| `<leader>D` | Normal | Type definition (via Telescope) |
| `<leader>ds` | Normal | Document symbols (via Telescope) |
| `<leader>ws` | Normal | Workspace symbols (via Telescope) |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal, Visual | Code action |
| `<leader>th` | Normal | Toggle inlay hints |
| `<leader>f` | All modes | Format buffer (via conform.nvim) |

### Automatic Behaviors

- **Highlight references**: When the cursor rests on a symbol (`CursorHold`), all references to that symbol in the buffer are highlighted. Highlights clear when the cursor moves.
- **Format on save**: All files are formatted on save (500ms timeout) with LSP fallback, except C/C++ where LSP formatting is disabled.
- **Lint on events**: nvim-lint runs on `BufWritePost`, `InsertLeave`, and `BufReadPost` for configured filetypes.

---

## Mason Ensure-Installed (Complete List)

All tools managed by Mason via `mason-tool-installer`:

**LSP Servers:**
- `lua-language-server`
- `gopls`
- `pyright`
- `typescript-language-server`
- `deno`
- `clangd`
- `tailwindcss-language-server`
- `eslint-lsp`
- `phpactor`

**Formatters:**
- `stylua`
- `clang-format`
- `prettierd`

**Linters:**
- `ruff`
- `golangci-lint`

**Not managed by Mason (external):**
- `rust_analyzer` (managed by rustaceanvim)
- `nextls` / `elixirls` (managed by elixir-tools.nvim)
- `gleam` (bundled with the Gleam compiler)
- `svelte-language-server` (must be installed separately)
- `nomicfoundation-solidity-language-server` (must be installed separately)
