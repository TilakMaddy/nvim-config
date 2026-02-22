return {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = { "folke/snacks.nvim" },
    init = function()
        vim.g.opencode_opts = {
            provider = {
                snacks = {
                    win = {
                        position = "float",
                        border = "none",
                        width = 0,
                        height = 0,
                        enter = true,
                        backdrop = 100,
                    },
                },
            },
        }
    end,
    config = function()
        -- Kill any orphaned opencode servers from previous sessions
        vim.fn.jobstart("pkill -f 'opencode.*--port' 2>/dev/null", { detach = true })

        local cfg = require "opencode.config"
        cfg.opts.provider.snacks.win = vim.tbl_deep_extend("force", cfg.opts.provider.snacks.win, {
            position = "float",
            border = "none",
            width = 0,
            height = 0,
            enter = true,
            backdrop = 100,
            wo = { winblend = 0 },
            bo = { scrollback = 0 },
        })

        -- Clean up opencode when Neovim exits
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                pcall(require("opencode").stop)
                vim.fn.system("pkill -f 'opencode.*--port' 2>/dev/null")
            end,
        })
    end,
    -- stylua: ignore
    keys = {
        { "<leader>aa", function() require("opencode").toggle() end, desc = "AI Toggle", mode = { "n", "t" } },
        { "<leader>aq", function()
            local ok, err = pcall(function()
                local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
                vim.api.nvim_feedkeys(esc, "nx", false)
                require("opencode").ask("@this: ", { submit = true })
            end)
            if not ok then
                vim.notify("AI Ask error: " .. tostring(err), vim.log.levels.ERROR)
            end
        end, mode = "v", desc = "AI Ask (selection)" },
        { "<leader>am", function() require("opencode").select() end, desc = "AI Menu", mode = { "n", "v" } },
    },
}
