# UI, Theme, and Appearance Configuration

## Overview

This Neovim configuration prioritizes a clean, minimal aesthetic. The guiding principles are:

- **Nerd Font icons everywhere.** A global flag (`vim.g.nerd_font = true` in `init.lua`) gates icon rendering across the statusline, which-key, Telescope, and devicons. Disable it in one place to fall back to plain ASCII.
- **Persistent theme selection.** The active color scheme is written to disk and restored on every startup, so switching themes is permanent across sessions.
- **Non-intrusive notifications.** `vim.notify` is replaced by snacks.nvim's notifier, giving styled floating popups with a searchable history buffer.
- **No visual clutter.** The built-in mode indicator is hidden (`showmode = false`), line wrapping is off, and the sign column is always visible to prevent layout shifts.

### Key source files

| File | Role |
|------|------|
| `lua/core/options.lua` | Vim options (numbers, colors, list chars, scroll) |
| `lua/plugins/colorscheme.lua` | Theme definitions and persistent theme picker |
| `lua/plugins/snacks.lua` | Notifier, terminal, lazygit, bigfile |
| `lua/plugins/mini.lua` | Statusline (mini.statusline) |
| `lua/plugins/editor.lua` | Which-key, todo-comments, highlight-colors, autopairs |
| `lua/plugins/image.lua` | In-terminal image rendering |

---

## Color Schemes

### Available themes

| Theme | Plugin | Notes |
|-------|--------|-------|
| **tokyonight** (night style) | `folke/tokyonight.nvim` | Default-priority plugin; comments overridden to orange |
| **catppuccin-mocha** | `catppuccin/nvim` | Italics disabled (`no_italic = true`) |
| **rose-pine** | `rose-pine/neovim` | Italics disabled (`disable_italics = true`) |
| **kanagawa** | `rebelot/kanagawa.nvim` | Compiled for speed; italic comments and keywords disabled |
| **everforest** | `sainnhe/everforest` | Italic comments disabled via `vim.g` flag |

All themes are loaded by lazy.nvim. `tokyonight.nvim` is given `priority = 1000` so it loads first and acts as the entry point for setting the initial colorscheme.

### Theme switching

**Keybinding:** `<leader>tt` -- "[T]oggle [T]heme (picker)"

This opens a Telescope colorscheme picker with **live preview** enabled. When you press `<CR>` on a selection:

1. The colorscheme is applied immediately via `vim.cmd.colorscheme()`.
2. The name is written to `~/.local/share/nvim/theme.txt`.
3. A notification confirms the save: `"Theme saved: <name>"`.

### Theme persistence

On startup, the `load_saved_theme()` function in `colorscheme.lua` reads `~/.local/share/nvim/theme.txt`. If the file exists and is non-empty, that theme is loaded. Otherwise, the fallback is `"catppuccin-mocha"`.

The file path is computed via `vim.fn.stdpath("data") .. "/theme.txt"`, which resolves to `~/.local/share/nvim/theme.txt` on standard installations.

### tokyonight customization

The tokyonight theme is configured with:

```lua
opts = {
    style = "night",
    on_highlights = function(hl, _)
        hl.Comment = { fg = "orange" }
    end,
},
```

This forces all comments to render in **orange** instead of the default muted gray, improving readability on dark backgrounds.

### How to add a new theme

1. Add a new plugin spec to `lua/plugins/colorscheme.lua`:

   ```lua
   {
       "author/new-theme.nvim",
       opts = {
           -- theme-specific options (disable italics, etc.)
       },
   },
   ```

2. Restart Neovim (or run `:Lazy sync`) so lazy.nvim installs the plugin.
3. Press `<leader>tt` and select the new theme from the Telescope picker. It will be persisted automatically.

No changes are needed in any other file. The Telescope colorscheme picker discovers all installed themes automatically.

---

## Statusline (mini.statusline)

**Plugin:** `echasnovski/mini.nvim` (statusline module)
**File:** `lua/plugins/mini.lua`

The statusline is provided by mini.statusline, configured for a minimal look:

```lua
local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.nerd_font })
```

- **Icons:** When `vim.g.nerd_font` is `true` (the default), the statusline uses Nerd Font icons for file types, git branch, diagnostics, and mode indicators.
- **Custom location format:** The default location section is overridden to display `%2l:%-2v`, which renders as `line:column` with minimal padding (e.g., `42:8 `). This replaces the more verbose default that includes line count and percentage.

```lua
statusline.section_location = function()
    return "%2l:%-2v"
end
```

The built-in mode indicator (`showmode`) is disabled in `options.lua` because mini.statusline already shows the current mode in its own section.

---

## Notifications (snacks.nvim notifier)

**Plugin:** `folke/snacks.nvim`
**File:** `lua/plugins/snacks.lua`

The snacks.nvim notifier replaces the built-in `vim.notify` with styled floating popups.

### Configuration

```lua
notifier = { enabled = true, width = { min = 60, max = 100 } },
```

- **Width:** Notifications are between 60 and 100 characters wide, adapting to content length.
- **Notification history window:** Configured at 90% of the editor width and height, with word wrap enabled:

  ```lua
  styles = {
      notification_history = {
          width = 0.9,
          height = 0.9,
          wo = { wrap = true },
      },
  },
  ```

### Keybinding

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>nh` | Normal | Open [N]otification [H]istory in a full-screen float |

The history buffer shows all notifications from the current session, wrapped for readability.

---

## Terminal (snacks.nvim terminal)

**Plugin:** `folke/snacks.nvim`
**File:** `lua/plugins/snacks.lua`

A floating terminal is available via snacks.nvim:

### Configuration

```lua
terminal = {
    win = {
        position = "float",
        border = "rounded",
        width = 0.8,
        height = 0.8,
    },
},
```

- **Position:** Centered floating window.
- **Border:** Rounded corners.
- **Size:** 80% of the editor width and height.

### Keybinding

| Key | Mode | Description |
|-----|------|-------------|
| `<C-\>` | Normal, Terminal | Toggle the floating terminal on/off |

The toggle works in both normal and terminal mode, so you can press `<C-\>` inside the terminal to dismiss it and `<C-\>` in normal mode to bring it back. The terminal session persists between toggles.

---

## Which-key

**Plugin:** `folke/which-key.nvim`
**File:** `lua/plugins/editor.lua`

Which-key displays a popup of available keybindings after pressing the leader key (or any prefix key) and waiting briefly. It loads on `VeryLazy` to avoid slowing down startup.

### Configuration

```lua
opts = {
    icons = {
        mappings = vim.g.nerd_font,
        keys = {},
    },
    spec = {
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "[G]rapple", mode = { "n", "v" } },
        { "<leader>a", group = "[A]I", mode = { "n", "v" } },
    },
},
```

### Leader key groups

| Prefix | Group | Modes | Purpose |
|--------|-------|-------|---------|
| `<leader>c` | Code | Normal, Visual | Code actions, formatting |
| `<leader>d` | Document | Normal | Document-related operations |
| `<leader>r` | Rename | Normal | Rename / refactor |
| `<leader>s` | Search | Normal | Telescope search commands |
| `<leader>w` | Workspace | Normal | Workspace / project operations |
| `<leader>t` | Toggle | Normal | Toggle features (theme, etc.) |
| `<leader>h` | Grapple | Normal, Visual | Grapple file tagging / navigation |
| `<leader>a` | AI | Normal, Visual | opencode AI assistant |

Icons are enabled when `vim.g.nerd_font` is `true`. The `keys` table is left empty, meaning default key icons are used.

---

## Editor Visual Features

**File:** `lua/core/options.lua`

These Vim options control the core visual appearance of the editor.

### Line numbers

```lua
vim.opt.number = true
vim.opt.relativenumber = true
```

Absolute line number on the current line, relative numbers on all other lines. This makes it easy to use `j`/`k` motions with counts.

### Cursor line highlight

```lua
vim.opt.cursorline = true
```

Highlights the entire line where the cursor sits, making it easy to track your position.

### Sign column

```lua
vim.opt.signcolumn = "yes"
```

The sign column (used by diagnostics, git signs, breakpoints) is **always visible**, even when there are no signs. This prevents the editor content from shifting left/right as signs appear and disappear.

### Line wrapping

```lua
vim.opt.wrap = false
```

Line wrapping is **disabled**. Long lines extend beyond the visible window and require horizontal scrolling.

### Break indent

```lua
vim.opt.breakindent = true
```

When lines *are* displayed as wrapped (e.g., in help buffers or when `wrap` is toggled on), the wrapped continuation lines preserve the indentation of the original line, maintaining visual structure.

### List characters

```lua
vim.opt.list = true
vim.opt.listchars = { tab = ">> ", trail = ".", nbsp = "?" }
```

Whitespace is rendered with visible characters:

| Character | Symbol | Description |
|-----------|--------|-------------|
| Tab | `>>` followed by a space | Makes tabs visually distinct from spaces |
| Trailing space | `.` (middle dot) | Exposes accidental trailing whitespace |
| Non-breaking space | `?` | Highlights non-breaking spaces that can cause subtle bugs |

### Scroll offset

```lua
vim.opt.scrolloff = 10
```

The cursor stays at least **10 lines** away from the top and bottom edges of the window. This provides context around the cursor position and prevents it from hitting the very edge of the screen.

### True color

```lua
vim.opt.termguicolors = true
```

Enables 24-bit RGB color in the terminal, which is required for modern color schemes to render correctly.

### Incremental substitution preview

```lua
vim.opt.inccommand = "split"
```

When running a substitution command (`:s/old/new/`), a **split preview window** opens showing all matches and their replacements in real time as you type. This makes find-and-replace operations visual and safe.

### Mode indicator

```lua
vim.opt.showmode = false
```

The built-in `-- INSERT --`, `-- VISUAL --` mode text in the command line is hidden because mini.statusline already displays the current mode.

---

## Color Highlighting (nvim-highlight-colors)

**Plugin:** `brenoprata10/nvim-highlight-colors`
**File:** `lua/plugins/editor.lua`

Renders inline color previews for color codes found in source files (hex, RGB, HSL, named CSS colors).

```lua
opts = {
    render = "virtual",
    enable_tailwind = false,
},
```

- **Render mode:** `"virtual"` -- colors are shown as virtual text (a colored square or swatch) next to the color code, rather than as background highlighting on the text itself.
- **Tailwind:** Disabled. Tailwind CSS class-based color detection is turned off to avoid unnecessary processing in non-Tailwind projects.
- **Lazy loading:** Loads on `BufReadPost` and `BufNewFile` events, so it activates only when a buffer is opened.

---

## TODO Comments (todo-comments.nvim)

**Plugin:** `folke/todo-comments.nvim`
**File:** `lua/plugins/editor.lua`

Highlights special comment keywords with distinctive colors and makes them searchable.

```lua
opts = { signs = false },
```

- **Recognized keywords:** `TODO`, `FIXME`, `HACK`, `NOTE`, `WARN`, `PERF`, `TEST` (defaults from the plugin).
- **Signs:** Disabled (`signs = false`). The keywords are highlighted inline in the text but do not add icons to the sign column.
- **Dependency:** Requires `nvim-lua/plenary.nvim`.
- **Lazy loading:** Loads on `BufReadPost` and `BufNewFile` events.

You can search all TODO comments in the project via Telescope (if the todo-comments Telescope extension is loaded) or via the `:TodoQuickFix` command.

---

## Image Rendering (image.nvim)

**Plugin:** `3rd/image.nvim`
**File:** `lua/plugins/image.lua`

Renders images directly inside the Neovim terminal using the Kitty graphics protocol.

### Configuration

```lua
opts = {
    backend = "kitty",
    processor = "magick_cli",
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" },
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    integrations = {
        markdown = {
            enabled = true,
            download_remote_images = true,
            only_render_image_at_cursor = false,
        },
    },
},
```

| Setting | Value | Description |
|---------|-------|-------------|
| `backend` | `"kitty"` | Uses the Kitty terminal graphics protocol for rendering |
| `processor` | `"magick_cli"` | Uses the ImageMagick CLI (`magick` command) for image processing |
| `hijack_file_patterns` | PNG, JPG, JPEG, GIF, WEBP, AVIF, SVG | Opening any of these file types displays the image instead of raw binary |
| `max_height_window_percentage` | `50` | Images are capped at 50% of the window height |
| `window_overlap_clear_enabled` | `true` | Clears images when windows overlap them |

### Markdown integration

- **Enabled:** Images referenced in Markdown files (`![alt](path)`) are rendered inline.
- **Remote images:** Automatically downloaded and displayed.
- **Cursor restriction:** Off -- all images in the visible area are rendered, not just the one at the cursor.

### SVG support

A custom `BufReadCmd` autocmd handles SVG files:

1. When an SVG file is opened, ImageMagick converts it to a temporary PNG at 300 DPI with a transparent background.
2. The converted PNG is loaded into the buffer for display.
3. The temporary PNG is cleaned up automatically when the buffer is deleted.

If the conversion fails, an error notification is shown.

### Requirements

- **Kitty terminal** (or any terminal supporting the Kitty graphics protocol).
- **ImageMagick** must be installed and available as the `magick` command on your `$PATH`.

---

## Lazygit Integration (snacks.nvim)

**Plugin:** `folke/snacks.nvim`
**File:** `lua/plugins/snacks.lua`

Opens Lazygit in a full-size floating window inside Neovim.

```lua
lazygit = {
    enabled = true,
    win = {
        width = 0,
        height = 0,
    },
},
```

The `width = 0` and `height = 0` configuration means the floating window uses the full editor dimensions (no padding).

### Keybinding

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gg` | Normal | Open Lazygit |

### Requirements

- **lazygit** must be installed and available on your `$PATH`.

---

## Big File Handling (snacks.nvim bigfile)

**Plugin:** `folke/snacks.nvim`
**File:** `lua/plugins/snacks.lua`

```lua
bigfile = { enabled = true },
```

When a large file is opened, snacks.nvim's bigfile module automatically disables expensive features to keep the editor responsive. This includes disabling:

- Treesitter highlighting
- LSP attachment
- Syntax highlighting
- Other heavy buffer-local features

The detection and thresholds use snacks.nvim's defaults. This runs transparently -- no keybindings or manual intervention needed.

---

## Snacks Input

**Plugin:** `folke/snacks.nvim`
**File:** `lua/plugins/snacks.lua`

```lua
input = { enabled = true },
```

The snacks input module replaces the default `vim.ui.input` with a styled floating input box. This affects any plugin or LSP action that prompts for text input (e.g., rename, code actions requiring input).

---

## Quick Reference: All UI Keybindings

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>tt` | Normal | Open theme picker with preview | colorscheme.lua |
| `<leader>nh` | Normal | Show notification history | snacks.lua |
| `<C-\>` | Normal, Terminal | Toggle floating terminal | snacks.lua |
| `<leader>gg` | Normal | Open Lazygit | snacks.lua |
