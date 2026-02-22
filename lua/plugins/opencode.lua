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
                        border = "rounded",
                        width = 0.95,
                        height = 0.95,
                        enter = true,
                        backdrop = 100,
                    },
                },
            },
        }
    end,
    config = function()
        local cfg = require("opencode.config")
        cfg.opts.provider.snacks.win =
            vim.tbl_deep_extend("force", cfg.opts.provider.snacks.win, {
                position = "float",
                border = "rounded",
                width = 0.95,
                height = 0.95,
                enter = true,
                backdrop = 100,
                wo = { winblend = 0 },
            })
    end,
    keys = {
        {
            "<leader>aa",
            function()
                require("opencode").toggle()
            end,
            desc = "AI Toggle",
            mode = { "n", "t" },
        },
        {
            "<leader>aa",
            function()
                require("opencode").ask "@this: "
            end,
            mode = "v",
            desc = "AI Ask (selection)",
        },
        {
            "<leader>am",
            function()
                require("opencode").select()
            end,
            desc = "AI Menu",
        },
    },
}
