-- Set leader keys (must happen before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd Font is installed
vim.g.nerd_font = true

-- Load core modules
require "core.options"
require "core.keymaps"
require "core.autocmds"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup {
    spec = {
        { import = "plugins" },
    },
    rocks = { enabled = false },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
}

-- Start at the path specified in arguments, restoring that directory's last session
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local arg = vim.fn.argv(0)
        if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
            local dir_buf = vim.api.nvim_get_current_buf()
            vim.cmd.cd(arg)
            -- Load outside the autocmd so restored buffers fire FileType (LSP, treesitter)
            vim.schedule(function()
                require("persistence").load()
                if vim.api.nvim_buf_is_valid(dir_buf) and vim.api.nvim_get_current_buf() ~= dir_buf then
                    vim.api.nvim_buf_delete(dir_buf, { force = true })
                end
            end)
        end
    end,
})

-- In an SSH Session, usually you don't have a display device attached. So the bytes need to be printed
-- to console for the host to copy them.

if vim.env.SSH_TTY then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy "+",
            ["*"] = require("vim.ui.clipboard.osc52").copy "*",
        },
        paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste "+",
            ["*"] = require("vim.ui.clipboard.osc52").paste "*",
        },
    }
end
