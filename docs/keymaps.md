# Neovim Keybindings Reference

Complete reference for every keybinding defined in this Neovim configuration.

---

## 1. Leader Key

| Key       | Role         | Source                  |
|-----------|--------------|-------------------------|
| `<Space>` | Leader       | `lua/core/options.lua`  |
| `<Space>` | Local Leader | `lua/core/options.lua`  |

Both `mapleader` and `maplocalleader` are set to the spacebar.

---

## 2. General

Core keymaps defined in `lua/core/keymaps.lua`.

| Keymap           | Mode | Action                           | Description                          |
|------------------|------|----------------------------------|--------------------------------------|
| `kj`             | `i`  | `<Esc>`                         | Escape insert mode                   |
| `<Esc>`          | `n`  | `:nohlsearch`                   | Clear search highlights              |
| `<Esc><Esc>`     | `t`  | `<C-\><C-n>`                   | Exit terminal mode                   |
| `<C-h>`          | `n`  | `<C-w><C-h>`                   | Move focus to the left window        |
| `<C-l>`          | `n`  | `<C-w><C-l>`                   | Move focus to the right window       |
| `<C-j>`          | `n`  | `<C-w><C-j>`                   | Move focus to the lower window       |
| `<C-k>`          | `n`  | `<C-w><C-k>`                   | Move focus to the upper window       |

---

## 3. Search (Telescope)

All search-related keymaps from `lua/plugins/telescope.lua`. Every binding uses the `<leader>s` prefix (plus a few extras).

| Keymap              | Mode | Action                                        | Description                                         |
|---------------------|------|-----------------------------------------------|-----------------------------------------------------|
| `<leader>sh`        | `n`  | `Telescope help_tags`                         | Search Help tags                                    |
| `<leader>sk`        | `n`  | `Telescope keymaps`                           | Search Keymaps                                      |
| `<leader>saf`       | `n`  | `Telescope find_files`                        | Search All Files (including untracked)              |
| `<leader>sf`        | `n`  | `Telescope git_files`                         | Search Git Files                                    |
| `<leader>ss`        | `n`  | `Telescope builtin`                           | Search Select Telescope (list all pickers)          |
| `<leader>sw`        | `n`  | `Telescope grep_string`                       | Search current Word under cursor                    |
| `<leader>sg`        | `n`  | `Telescope live_grep`                         | Search by Grep (live)                               |
| `<leader>sG`        | `n`  | `Telescope live_grep` (no-ignore, hidden)     | Search by Grep including ignored and hidden files   |
| `<leader>sD`        | `n`  | `Telescope live_grep` (scoped to directory)   | Search Directory -- prompts for a directory, then greps within it |
| `<leader>sd`        | `n`  | `Telescope diagnostics`                       | Search Diagnostics (vertical layout)                |
| `<leader>sr`        | `n`  | `Telescope resume`                            | Search Resume (reopen last picker)                  |
| `<leader>s.`        | `n`  | `Telescope oldfiles`                          | Search Recent Files                                 |
| `<leader><leader>`  | `n`  | `Telescope buffers`                           | Find existing buffers                               |
| `<leader>/`         | `n`  | `current_buffer_fuzzy_find` (dropdown theme)  | Fuzzily search in current buffer                    |
| `<leader>s/`        | `n`  | `live_grep` (open files only)                 | Search in Open Files via grep                       |
| `<leader>sn`        | `n`  | `find_files` (cwd = nvim config)              | Search Neovim config files                          |
| `<leader>sF`        | `n`  | `find_files` (prompts for directory)          | Search Files in a specific directory                |

---

## 4. LSP

Keymaps set on `LspAttach` in `lua/plugins/lsp.lua`. These are only active in buffers with an attached LSP server.

| Keymap         | Mode     | Action                                       | Description                       |
|----------------|----------|----------------------------------------------|-----------------------------------|
| `gd`           | `n`      | `Telescope lsp_definitions`                  | Goto Definition                   |
| `gr`           | `n`      | `Telescope lsp_references`                   | Goto References                   |
| `gI`           | `n`      | `Telescope lsp_implementations`              | Goto Implementation               |
| `gD`           | `n`      | `vim.lsp.buf.declaration`                    | Goto Declaration                  |
| `<leader>D`    | `n`      | `Telescope lsp_type_definitions`             | Type Definition                   |
| `<leader>ds`   | `n`      | `Telescope lsp_document_symbols`             | Document Symbols                  |
| `<leader>ws`   | `n`      | `Telescope lsp_dynamic_workspace_symbols`    | Workspace Symbols                 |
| `<leader>rn`   | `n`      | `vim.lsp.buf.rename`                         | Rename symbol                     |
| `<leader>ca`   | `n`, `x` | `vim.lsp.buf.code_action`                   | Code Action                       |
| `<leader>th`   | `n`      | Toggle `vim.lsp.inlay_hint`                  | Toggle Inlay Hints (if supported) |

---

## 5. Completion (blink.cmp)

Insert-mode keymaps from `lua/plugins/completion.lua`. Active inside the completion menu provided by blink.cmp.

| Keymap      | Action                   | Description                                |
|-------------|--------------------------|--------------------------------------------|
| `<C-n>`     | `select_next`            | Select next completion item                |
| `<C-p>`     | `select_prev`            | Select previous completion item            |
| `<Down>`    | `select_next`            | Select next completion item                |
| `<Up>`      | `select_prev`            | Select previous completion item            |
| `<C-b>`     | `scroll_documentation_up`| Scroll documentation up                    |
| `<C-f>`     | `scroll_documentation_down`| Scroll documentation down                |
| `<Tab>`     | `select_and_accept`      | Accept selected completion                 |
| `<C-y>`     | `select_and_accept`      | Accept selected completion                 |
| `<C-Space>` | `show`                   | Manually trigger completion menu           |
| `<C-e>`     | `hide`                   | Dismiss completion menu                    |
| `<C-l>`     | `snippet_forward`        | Jump to next snippet placeholder           |
| `<C-h>`     | `snippet_backward`       | Jump to previous snippet placeholder       |

All keymaps fall back to their default behavior when the completion menu is not visible.

---

## 6. Navigation

### nvim-tree (`lua/plugins/navigation.lua`)

| Keymap         | Mode | Action                   | Description                 |
|----------------|------|--------------------------|-----------------------------|
| `<leader>fj`   | `n`  | `:NvimTreeToggle`        | Toggle file tree sidebar    |
| `<leader>ff`   | `n`  | `:NvimTreeFindFile`      | Reveal current file in tree |

### Grapple (`lua/plugins/navigation.lua`)

Bookmark-style file navigation scoped to the current Git repo.

| Keymap         | Mode | Action                       | Description                      |
|----------------|------|------------------------------|----------------------------------|
| `<leader>ha`   | `n`  | `:Grapple toggle`            | Add or remove file from tags     |
| `<leader>hf`   | `n`  | `:Grapple toggle_tags`       | Open Grapple tag picker          |
| `<C-n>`         | `n`  | `:Grapple cycle_tags next`   | Cycle to next tagged file        |
| `<C-p>`         | `n`  | `:Grapple cycle_tags prev`   | Cycle to previous tagged file    |

### Oil (`lua/plugins/oil.lua`)

File-system editor in a buffer.

| Keymap | Mode | Action       | Description                             |
|--------|------|--------------|-----------------------------------------|
| `-`    | `n`  | `:Oil`       | Open parent directory in Oil            |
| `q`    | `n`  | Close Oil    | Close the Oil buffer (inside Oil only)  |

Note: `<C-s>` is explicitly disabled inside Oil to avoid overriding the split binding.

---

## 7. Git

| Keymap         | Mode     | Action                 | Source                         | Description                     |
|----------------|----------|------------------------|--------------------------------|---------------------------------|
| `<leader>gs`   | `n`      | `:Git`                 | `lua/plugins/git.lua`          | Open Fugitive Git status window |
| `<leader>gg`   | `n`      | `Snacks.lazygit.open()`| `lua/plugins/snacks.lua`       | Open Lazygit in a float         |

Gitsigns (`lua/plugins/git.lua`) provides sign-column indicators (`+`, `~`, `_`, etc.) but does not define additional keymaps in this configuration.

---

## 8. Motion (Flash)

From `lua/plugins/flash.lua`. Flash provides label-based jump motions.

| Keymap | Mode           | Action                          | Description                                    |
|--------|----------------|---------------------------------|------------------------------------------------|
| `s`    | `n`, `x`, `o`  | `flash.jump()`                  | Flash jump -- type characters then pick label  |
| `S`    | `n`, `x`, `o`  | `flash.treesitter()`            | Flash Treesitter -- select a treesitter node    |
| `r`    | `o`             | `flash.remote()`                | Remote Flash -- operate on a remote location    |
| `R`    | `o`, `x`        | `flash.treesitter_search()`     | Treesitter Search -- search + select TS node    |

Character motions (`f`, `F`, `t`, `T`) are enhanced with jump labels (configured via `modes.char.jump_labels = true`).

---

## 9. Code

### Formatting (`lua/plugins/formatting.lua`)

| Keymap       | Mode       | Action                                   | Description              |
|--------------|------------|------------------------------------------|--------------------------|
| `<leader>f`  | `""` (all) | `conform.format({ async = true, lsp_format = "fallback" })` | Format current buffer |

Format-on-save is also enabled (500 ms timeout, `lsp_format = "fallback"` except for C/C++).

### Diagnostics (`lua/core/keymaps.lua`)

| Keymap        | Mode | Action                           | Description                         |
|---------------|------|----------------------------------|-------------------------------------|
| `<leader>q`   | `n`  | `vim.diagnostic.setloclist`      | Open diagnostic quickfix list       |
| `<leader>pd`  | `n`  | `vim.diagnostic.open_float`      | Show diagnostics in a floating popup|

---

## 10. Treesitter Text Objects

From `lua/plugins/treesitter.lua` via `nvim-treesitter-textobjects`.

### Selection (Visual `x` and Operator-pending `o` modes)

| Keymap | Query               | Description                   |
|--------|---------------------|-------------------------------|
| `af`   | `@function.outer`   | Select around a function      |
| `if`   | `@function.inner`   | Select inside a function      |
| `ac`   | `@class.outer`      | Select around a class         |
| `ic`   | `@class.inner`      | Select inside a class         |
| `aa`   | `@parameter.outer`  | Select around a parameter     |
| `ia`   | `@parameter.inner`  | Select inside a parameter     |
| `al`   | `@loop.outer`       | Select around a loop          |
| `il`   | `@loop.inner`       | Select inside a loop          |

### Movement (Normal `n`, Visual `x`, and Operator-pending `o` modes)

| Keymap | Action                         | Description                    |
|--------|--------------------------------|--------------------------------|
| `]f`   | `goto_next_start`              | Jump to next function start    |
| `[f`   | `goto_previous_start`          | Jump to previous function start|
| `]c`   | `goto_next_start`              | Jump to next class start       |
| `[c`   | `goto_previous_start`          | Jump to previous class start   |
| `]a`   | `goto_next_start`              | Jump to next argument          |
| `[a`   | `goto_previous_start`          | Jump to previous argument      |

### Swap (Normal mode)

| Keymap         | Action                          | Description                    |
|----------------|---------------------------------|--------------------------------|
| `<leader>xa`   | `swap.swap_next(@parameter.inner)` | Swap current argument with next |
| `<leader>xA`   | `swap.swap_previous(@parameter.inner)` | Swap current argument with previous |

---

## 11. UI

| Keymap         | Mode       | Action                          | Source                            | Description                              |
|----------------|------------|---------------------------------|-----------------------------------|------------------------------------------|
| `<leader>tt`   | `n`        | Telescope colorscheme picker    | `lua/plugins/colorscheme.lua`     | Pick and persist a colorscheme           |
| `<leader>u`    | `n`        | `:UndotreeToggle`               | `lua/plugins/undotree.lua`        | Toggle the undo tree panel               |
| `<C-\>`        | `n`, `t`   | `Snacks.terminal.toggle()`      | `lua/plugins/snacks.lua`          | Toggle floating terminal                 |
| `<leader>nh`   | `n`        | `Snacks.notifier.show_history()`| `lua/plugins/snacks.lua`          | Show notification history                |

### Which-Key Groups (`lua/plugins/editor.lua`)

These are group labels shown by which-key; they do not perform an action themselves.

| Prefix       | Mode       | Group Label   |
|--------------|------------|---------------|
| `<leader>c`  | `n`, `x`   | [C]ode        |
| `<leader>d`  | `n`        | [D]ocument    |
| `<leader>r`  | `n`        | [R]ename      |
| `<leader>s`  | `n`        | [S]earch      |
| `<leader>w`  | `n`        | [W]orkspace   |
| `<leader>t`  | `n`        | [T]oggle      |
| `<leader>h`  | `n`, `v`   | [G]rapple     |

---

## 12. AI (Avante)

From `lua/plugins/avante.lua`. Uses OpenRouter (Claude Sonnet 4) as the AI backend.

| Keymap         | Mode | Action                                           | Description                                    |
|----------------|------|--------------------------------------------------|------------------------------------------------|
| `<leader>aa`   | `n`  | Toggle Avante sidebar (open zen / close sidebar) | Toggle Avante AI sidebar in zen mode           |
| `<leader>aa`   | `v`  | `avante.api.zen_mode()`                          | Open Avante zen mode with visual selection     |
| `<leader>an`   | `n`  | `avante.api.ask({ new_chat = true })`            | Start a new Avante chat in zen mode            |
| `<leader>am`   | `n`  | `:AvanteModels`                                  | Switch Avante AI model                         |

---

## 13. Markdown

From `lua/plugins/markdown-preview.lua`.

| Keymap         | Mode | Action                         | Description                          |
|----------------|------|--------------------------------|--------------------------------------|
| `<leader>mp`   | `n`  | `:MarkdownPreviewToggle`       | Toggle live Markdown preview in browser |

---

## 14. Elixir

From `lua/plugins/lang-elixir.lua`. These keymaps are buffer-local and only active when ElixirLS is attached.

| Keymap          | Mode | Action                 | Description                             |
|-----------------|------|------------------------|-----------------------------------------|
| `<leader>exp`   | `n`  | `:ElixirFromPipe`      | Convert pipe operator to function call  |
| `<leader>exo`   | `n`  | `:ElixirToPipe`        | Convert function call to pipe operator  |
| `<leader>exm`   | `v`  | `:ElixirExpandMacro`   | Expand macro (visual selection)         |

---

## 15. Mini.surround

From `lua/plugins/mini.lua` via `mini.surround` with default mappings.

| Keymap            | Mode       | Action                             | Description                                     |
|-------------------|------------|------------------------------------|-------------------------------------------------|
| `sa{motion}{char}`| `n`, `v`   | Add surrounding                    | Add surrounding character (e.g., `saiw"` wraps word in quotes) |
| `sd{char}`        | `n`        | Delete surrounding                 | Delete surrounding character (e.g., `sd"` removes surrounding quotes) |
| `sr{old}{new}`    | `n`        | Replace surrounding                | Replace surrounding character (e.g., `sr"'` changes `"` to `'`) |
| `sf`              | `n`        | Find surrounding (right)           | Move cursor to next right surrounding            |
| `sF`              | `n`        | Find surrounding (left)            | Move cursor to next left surrounding             |
| `sh`              | `n`        | Highlight surrounding              | Highlight surrounding pairs                      |
| `sn`              | `n`        | Update `n_lines` for surrounding   | Change the number of lines searched for surrounding |

`mini.ai` is also loaded and extends the built-in `a`/`i` text objects with additional targets (up to 500 lines of context).

---

## Quick Reference Card

| Category          | Key Pattern           | Examples                                |
|-------------------|-----------------------|-----------------------------------------|
| Search            | `<leader>s` + key     | `<leader>sg` grep, `<leader>sf` files   |
| LSP               | `g` + key             | `gd` definition, `gr` references        |
| LSP (leader)      | `<leader>` + key      | `<leader>rn` rename, `<leader>ca` action|
| Navigation        | `<leader>f` / `<leader>h` | `<leader>fj` tree, `<leader>ha` grapple |
| Git               | `<leader>g` + key     | `<leader>gs` status, `<leader>gg` lazygit|
| Code              | `<leader>f` / `<leader>q` | `<leader>f` format, `<leader>q` diagnostics |
| Treesitter move   | `]` / `[` + key       | `]f` next function, `[c` prev class     |
| Treesitter swap   | `<leader>x` + key     | `<leader>xa` swap next arg              |
| UI                | `<leader>t` + key     | `<leader>tt` theme, `<leader>th` hints  |
| AI                | `<leader>a` + key     | `<leader>aa` avante, `<leader>an` new   |
| Surround          | `s` + `a`/`d`/`r`    | `sa` add, `sd` delete, `sr` replace     |
| Window            | `<C-h/j/k/l>`        | Move focus between splits               |
| Terminal          | `<C-\>`               | Toggle floating terminal                |
