# Navigation, Motion, and Search

## Overview

This Neovim configuration provides multiple complementary navigation paradigms, each suited to different tasks:

| Paradigm | Plugin | Purpose |
|---|---|---|
| File tree | nvim-tree | Sidebar explorer for browsing project structure |
| File tagging | Grapple | Bookmark important files for instant access (like Harpoon) |
| Fuzzy finding | Telescope | Search files, content, buffers, keymaps, and more |
| File editing | Oil | Edit the filesystem as if it were a Neovim buffer |
| Fast motion | Flash | Label-based jumping for rapid cursor movement |
| Structural nav | Treesitter textobjects | Select and move by functions, classes, arguments, loops |
| Window nav | Core keymaps | Move between splits with Ctrl+h/j/k/l |

These tools are not mutually exclusive. The recommended approach is to combine them based on context: Telescope to find and open files, Grapple to pin the ones you revisit constantly, nvim-tree to explore unfamiliar directory structures, Oil to perform quick file renames or moves, Flash to jump within a buffer, and Treesitter motions to operate on code structures.

---

## Telescope (Fuzzy Finder)

**Plugin:** `nvim-telescope/telescope.nvim`
**Source:** `lua/plugins/telescope.lua`

Telescope is the primary search interface. It uses `fd` for file listing and `ripgrep` for content search, with a native FZF sorter for speed.

### Performance Configuration

- **Sorter:** `fzf-native` (compiled C, replaces the default Lua sorter). Smart-case matching enabled.
- **Sorting strategy:** Ascending, with the prompt at the top of the layout.
- **Preview file size limit:** 1 MB -- files larger than this are not previewed.
- **Preview timeout:** 250 ms.
- **Path display:** Truncated to keep results readable.
- **Ignored patterns:** The following are excluded from all Telescope searches by default:

  ```
  node_modules/
  .git/
  *.lock
  dist/
  build/
  target/
  vendor/
  *.min.js
  ```

### Extensions

| Extension | Purpose |
|---|---|
| `telescope-fzf-native.nvim` | Compiled FZF algorithm for fast, accurate fuzzy matching. Overrides both the generic and file sorters. Only loaded if `make` is available on the system. |
| `telescope-live-grep-args.nvim` | Enables passing ripgrep arguments (file type filters, globs, flags) directly in the live grep prompt. Powers `<leader>sg` and `<leader>sD`. |

### Keybindings

All Telescope keybindings use the `<leader>s` prefix (mnemonic: **S**earch), except for buffer search which uses `<leader><leader>` and in-buffer fuzzy find which uses `<leader>/`.

| Keybinding | Action | Description |
|---|---|---|
| `<leader>sf` | `Telescope git_files` | Search files tracked by Git (fast, skips ignored files) |
| `<leader>saf` | `Telescope find_files` | Search ALL files in the working directory (includes untracked) |
| `<leader>sF` | `find_files` with directory prompt | Prompts for a directory, then searches files within it |
| `<leader>sg` | `live_grep_args` | Live grep with ripgrep arg support (type filters, globs). See [Grep Args](#grep-args-usage) below. |
| `<leader>sG` | `live_grep` with `--no-ignore --hidden` | Live grep including hidden and ignored files |
| `<leader>sD` | `live_grep_args` with directory prompt | Prompts for a directory, then greps within it (supports rg args) |
| `<leader>sw` | `Telescope grep_string` | Grep for the word currently under the cursor |
| `<leader>sd` | `Telescope diagnostics` | Search LSP diagnostics (vertical layout, large preview) |
| `<leader>sh` | `Telescope help_tags` | Search Neovim help tags |
| `<leader>sk` | `Telescope keymaps` | Search all registered keymaps |
| `<leader>ss` | `Telescope builtin` | Browse all available Telescope pickers |
| `<leader>sr` | `Telescope resume` | Re-open the last Telescope picker with previous query |
| `<leader>s.` | `Telescope oldfiles` | Search recently opened files |
| `<leader>sn` | `find_files` in Neovim config | Search files inside `~/.config/nvim` |
| `<leader>s/` | `live_grep` in open files | Grep only within currently open buffers |
| `<leader>/` | `current_buffer_fuzzy_find` | Fuzzy search inside the current buffer (dropdown, no preview) |
| `<leader><leader>` | `Telescope buffers` | Find and switch between open buffers |

### Grep Args Usage

`<leader>sg` and `<leader>sD` use [telescope-live-grep-args](https://github.com/nvim-telescope/telescope-live-grep-args.nvim), which lets you pass ripgrep flags directly in the search prompt. `auto_quoting` is enabled, so your search term is automatically quoted.

**Picker shortcuts (insert mode):**

| Key | Action |
|---|---|
| `Ctrl+k` | Quote the search term (general purpose, for manually appending any rg flag) |
| `Ctrl+t` | Quote the search term + append `-t ` (file **t**ype filter) |
| `Ctrl+i` | Quote the search term + append `--iglob ` (case-insensitive **g**lob filter) |

**Example workflow — search `pr` in only Lua files:**

1. Press `<leader>sg`
2. Type `pr`
3. Press `Ctrl+t`
4. Type `lua`
5. The prompt now reads `"pr" -t lua` — only Lua files are shown

**Common rg flag examples:**

| Prompt | Effect |
|---|---|
| `"search_term" -tlua` | Only Lua files |
| `"search_term" -tpy` | Only Python files |
| `"search_term" --iglob *.lua` | Glob: only `.lua` files |
| `"search_term" --iglob !*.md` | Glob: exclude markdown files |
| `"search_term" -g "lua/plugins/*.lua"` | Glob: only `.lua` files under `lua/plugins/` |
| `"search_term" --no-ignore` | Include files ignored by `.gitignore` |

**Glob pattern reference:**

| Pattern | Matches |
|---|---|
| `*` | Anything within one directory level |
| `**` | Anything across all directory levels |
| `?` | Single character |
| `{a,b}` | Either `a` or `b` |
| `!pattern` | Exclude files matching the pattern |

### Tips

- **Use `<leader>sf` (git files) as your default file finder.** It is faster than `<leader>saf` because it only searches files tracked by Git, skipping `node_modules`, build artifacts, and other ignored paths.
- **Use `<leader>saf` when you need to find files not yet tracked by Git**, such as newly created files that have not been staged.
- **Use `<leader>sG` when you need to search through vendored or generated code** that is normally ignored by ripgrep.
- **Use `<leader>sr` (resume) to get back to your last search** without retyping the query -- especially useful after opening a result and wanting to continue browsing.
- **Use `<leader>sD` to scope a grep to a specific subdirectory** when the project is large and you know where to look.
- **Use `Ctrl+t` in the grep picker** to quickly filter by file type without manually typing quotes and flags.

---

## nvim-tree (File Tree)

**Plugin:** `nvim-tree/nvim-tree.lua`
**Source:** `lua/plugins/navigation.lua`

A sidebar file explorer for visually browsing project structure. Lazy-loaded on command.

### Configuration

| Setting | Value | Effect |
|---|---|---|
| View width | 30 columns | Sidebar takes 30 columns on the left |
| Dotfiles filter | `true` | Hidden/dot files are filtered out by default (toggle with `H` inside the tree) |
| Group empty folders | `true` | Consecutive single-child directories are collapsed into one line (e.g., `src/utils/helpers`) |
| Sort | Case-sensitive | Uppercase filenames sort before lowercase |
| Netrw | Disabled (via lazy.nvim `cmd` guard) | nvim-tree replaces the default file explorer only when invoked |

### Keybindings

| Keybinding | Action | Description |
|---|---|---|
| `<leader>fj` | `NvimTreeToggle` | Toggle the file tree sidebar open/closed |
| `<leader>ff` | `NvimTreeFindFile` | Open the tree and jump to the current file's location |

### Tips

- **Use `<leader>ff` (find file) rather than `<leader>fj` (toggle)** when you want context -- it opens the tree with the current file highlighted, so you immediately see sibling files and the directory structure around your current location.
- Inside the tree, press `a` to create a new file, `d` to delete, `r` to rename, and `c`/`p` to copy/paste.
- Press `H` inside the tree to toggle display of hidden (dot) files.
- Press `?` inside the tree to see the full list of built-in keymaps.

---

## Grapple (File Tagging)

**Plugin:** `cbochs/grapple.nvim`
**Source:** `lua/plugins/navigation.lua`

Grapple lets you tag (bookmark) files for instant access. It works like Harpoon: you maintain a short list of files you are actively working on and jump between them without searching.

### Configuration

| Setting | Value | Effect |
|---|---|---|
| Scope | `git` | Tags are scoped to the Git repository root. Each project has its own independent tag list. |
| Quick select | `123456789` | Tags are numbered 1-9 for quick selection from the tag window. |

### Keybindings

| Keybinding | Action | Description |
|---|---|---|
| `<leader>ha` | `Grapple toggle` | Tag or untag the current file. If already tagged, removes the tag. |
| `<leader>hf` | `Grapple toggle_tags` | Open the tag list window. Press a number (1-9) to jump to that tag. |
| `<C-n>` | `Grapple cycle_tags next` | Jump to the next tagged file (wraps around) |
| `<C-p>` | `Grapple cycle_tags prev` | Jump to the previous tagged file (wraps around) |

### Workflow Tips

- **Tag the 3-5 files you are actively editing.** A typical workflow: the main source file, its test file, a config file, and maybe a type definition file.
- **Use `<C-n>` / `<C-p>` to cycle** when bouncing between just two or three files -- it is faster than opening the tag list.
- **Use `<leader>hf` and number keys** when you have more files tagged and want to jump to a specific one by position.
- **Tags persist across sessions** within a Git project. Restarting Neovim does not lose your tags.
- **Remove stale tags** by visiting the file and pressing `<leader>ha` again (toggle off), or by opening the tag list and deleting entries.

---

## Oil (File Browser)

**Plugin:** `stevearc/oil.nvim`
**Source:** `lua/plugins/oil.lua`

Oil presents a directory listing as an editable Neovim buffer. You navigate the filesystem by moving through the buffer, and you perform file operations (rename, move, delete, create) by editing text and saving.

### Configuration

| Setting | Value | Effect |
|---|---|---|
| Default file explorer | `false` | Oil does not replace netrw globally; it is invoked explicitly |
| Show hidden files | `true` | Dotfiles and hidden directories are visible |
| Float padding | 4 | Floating window has 4 columns/rows of padding |
| Float max width | 120 | Floating window caps at 120 columns |
| Float max height | 40 | Floating window caps at 40 rows |
| `q` keymap | Close Oil | Press `q` to close the Oil buffer |
| `<C-s>` | Disabled | The default Oil `<C-s>` (save) is disabled to avoid overriding split navigation |

### Keybindings

| Keybinding | Action | Description |
|---|---|---|
| `-` | `Oil` | Open the parent directory of the current file in an Oil buffer |

### Tips

- **To rename a file:** open Oil with `-`, edit the filename text in the buffer, then save with `:w`. Oil will execute the rename.
- **To move a file:** cut the line (delete it), navigate to the target directory, paste it there, and save.
- **To create a file:** type a new filename on a blank line and save.
- **To delete a file:** delete the line and save. Oil will prompt for confirmation.
- **Navigate into directories** by pressing `<CR>` on a directory entry. Press `-` again to go up.
- Oil is especially useful for **batch renames**: open a directory, use Neovim's built-in search and replace (`:s`) across the filenames, then save once to apply all renames.

---

## Flash (Motion)

**Plugin:** `folke/flash.nvim`
**Source:** `lua/plugins/flash.lua`

Flash provides label-based jumping: type a character (or characters) to search for, and Flash overlays jump labels on every match. Press the label to teleport your cursor there instantly.

### Configuration

| Setting | Value | Effect |
|---|---|---|
| Char mode jump labels | `true` | Jump labels appear on `f`/`F`/`t`/`T` character searches, not just Flash searches |
| Search mode integration | `false` | Flash does NOT hijack `/` and `?` searches; regular search behaves normally |

### Keybindings

| Keybinding | Modes | Action | Description |
|---|---|---|---|
| `s` | Normal, Visual, Operator-pending | `flash.jump()` | Start a Flash search; type characters then press a label to jump |
| `S` | Normal, Visual, Operator-pending | `flash.treesitter()` | Select a Treesitter node; labels appear on code structures (functions, blocks, etc.) |
| `r` | Operator-pending | `flash.remote()` | Remote Flash: perform an operator on a remote location without moving the cursor |
| `R` | Operator-pending, Visual | `flash.treesitter_search()` | Combine Treesitter selection with search to target specific nodes |

### Tips

- **`s` is your go-to for fast in-buffer movement.** It replaces the need to scan for line numbers or count words. Type `s`, then type 1-2 characters near your target, then press the label.
- **`S` (Treesitter jump) is powerful for selecting entire code blocks.** In visual or operator-pending mode, it highlights complete functions, if-blocks, loops, etc. for selection.
- **`r` (remote flash) lets you operate on distant text without moving.** For example, in operator-pending mode after pressing `d` (delete), press `r`, then jump to a location -- the delete applies at the remote location while your cursor stays put.
- **`f`/`F`/`t`/`T` also show jump labels** thanks to the `jump_labels = true` char mode setting. This means Flash enhances Neovim's built-in character motions without replacing them.
- **Regular `/` search is not affected.** Flash's search integration is explicitly disabled, so `/` and `?` behave as normal Neovim search.

---

## Treesitter Navigation

**Plugin:** `nvim-treesitter/nvim-treesitter-textobjects`
**Source:** `lua/plugins/treesitter.lua`

Treesitter textobjects let you select, move between, and swap code structures based on the syntax tree rather than raw text patterns. This works across all languages with Treesitter parsers installed.

### Text Object Selection

These work in **Visual** and **Operator-pending** modes. Use them with operators like `d`, `c`, `y`, `v`, etc.

| Keybinding | Query | Description | Example |
|---|---|---|---|
| `af` | `@function.outer` | Select the entire function (including signature and braces) | `daf` deletes a whole function |
| `if` | `@function.inner` | Select the function body only | `vif` visually selects function contents |
| `ac` | `@class.outer` | Select the entire class | `yac` yanks a whole class |
| `ic` | `@class.inner` | Select the class body only | `cic` changes class contents |
| `aa` | `@parameter.outer` | Select a function argument (including separator) | `daa` deletes an argument and its comma |
| `ia` | `@parameter.inner` | Select a function argument value only | `via` selects just the argument value |
| `al` | `@loop.outer` | Select the entire loop | `dal` deletes a whole loop |
| `il` | `@loop.inner` | Select the loop body only | `vil` selects loop contents |

Lookahead is enabled: if the cursor is not inside a matching node, the selection jumps forward to the next one.

### Movement Between Code Structures

These work in **Normal**, **Visual**, and **Operator-pending** modes.

| Keybinding | Direction | Target | Description |
|---|---|---|---|
| `]f` | Next | `@function.outer` | Jump to the start of the next function |
| `[f` | Previous | `@function.outer` | Jump to the start of the previous function |
| `]c` | Next | `@class.outer` | Jump to the start of the next class |
| `[c` | Previous | `@class.outer` | Jump to the start of the previous class |
| `]a` | Next | `@parameter.inner` | Jump to the next function argument |
| `[a` | Previous | `@parameter.inner` | Jump to the previous function argument |

### Argument Swapping

These work in **Normal** mode only.

| Keybinding | Action | Description |
|---|---|---|
| `<leader>xa` | Swap with next argument | Swap the argument under the cursor with the one to its right |
| `<leader>xA` | Swap with previous argument | Swap the argument under the cursor with the one to its left |

### Tips

- **`]f` and `[f` are the fastest way to navigate between functions** in a file. They jump precisely to function boundaries regardless of blank lines or comments.
- **Combine text objects with operators** for surgical edits: `daf` to delete a function, `caa` to change an argument, `yic` to yank a class body.
- **Use argument swapping (`<leader>xa` / `<leader>xA`)** to reorder function parameters without cutting and pasting.
- These motions are **language-aware**: they work correctly for Python functions, Rust `impl` blocks, JavaScript arrow functions, Go methods, etc.

---

## Window Navigation

**Source:** `lua/core/keymaps.lua`

Standard window/split navigation using Ctrl + hjkl, matching Vim's directional conventions.

| Keybinding | Action | Description |
|---|---|---|
| `<C-h>` | `<C-w><C-h>` | Move focus to the left window |
| `<C-j>` | `<C-w><C-j>` | Move focus to the lower window |
| `<C-k>` | `<C-w><C-k>` | Move focus to the upper window |
| `<C-l>` | `<C-w><C-l>` | Move focus to the right window |

### Other Core Navigation Keymaps

| Keybinding | Mode | Action | Description |
|---|---|---|---|
| `kj` | Insert | `<Esc>` | Exit insert mode |
| `<Esc>` | Normal | `:nohlsearch` | Clear search highlights |
| `<leader>q` | Normal | `vim.diagnostic.setloclist` | Open diagnostics in the quickfix list |
| `<leader>pd` | Normal | `vim.diagnostic.open_float` | Show diagnostics for the current line in a floating window |
| `<Esc><Esc>` | Terminal | `<C-\><C-n>` | Exit terminal mode |

---

## Workflow Tips

### Finding and opening a file you know the name of
1. Press `<leader>sf` to search Git files by name.
2. Type part of the filename, select the result, press `<CR>`.

### Searching for a string across the project
1. Press `<leader>sg` to start a live grep.
2. Type the search term. Results update as you type.
3. To filter by file type, press `Ctrl+t` then type the type (e.g., `lua`, `py`).
4. To filter by glob, press `Ctrl+i` then type the pattern (e.g., `*.lua`, `!*.md`).
5. To include `node_modules` or hidden files, use `<leader>sG` instead.
6. To scope to a specific directory, use `<leader>sD`.

### Working on a fixed set of files
1. Open each file you will be working on.
2. In each file, press `<leader>ha` to tag it with Grapple.
3. Use `<C-n>` / `<C-p>` to cycle between tagged files, or `<leader>hf` then a number key.

### Exploring an unfamiliar codebase
1. Press `<leader>fj` to open the file tree and browse the directory structure.
2. Press `<leader>ff` to reveal your current file's location in the tree.
3. Use Oil (`-`) to quickly inspect directory contents in a buffer.

### Renaming or reorganizing files
1. Press `-` to open Oil in the current file's parent directory.
2. Edit filenames directly in the buffer (use `:s` for batch renames).
3. Save with `:w` -- Oil executes all file operations.

### Jumping to a specific location in the current buffer
1. Press `s` and type 1-2 characters near your target.
2. Press the highlighted label to jump there instantly.
3. Alternatively, use `<leader>/` for a fuzzy search within the current buffer.

### Editing a function or code block
1. Use `]f` / `[f` to navigate to the target function.
2. Use `vaf` to visually select the entire function, or `vif` for just the body.
3. Use `daf` to delete it, `yaf` to yank it, or `cif` to change the body.

### Reordering function arguments
1. Place the cursor on the argument you want to move.
2. Press `<leader>xa` to swap it with the next argument, or `<leader>xA` for the previous one.
3. Repeat as needed.

### Navigating between splits with a file tree open
1. Open the file tree with `<leader>fj`.
2. Use `<C-h>` to move focus into the tree, `<C-l>` to move back to the editor.
3. This also works with any vertical or horizontal split layout.
