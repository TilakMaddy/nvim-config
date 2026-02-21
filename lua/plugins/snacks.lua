return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
        notifier = { enabled = true, width = { min = 60, max = 100 } },
        styles = {
            notification_history = {
                width = 0.9,
                height = 0.9,
                wo = { wrap = true },
            },
        },
        input = { enabled = true },
        lazygit = {
            enabled = true,
            win = {
                width = 0,
                height = 0,
            },
        },
        bigfile = { enabled = true },
        terminal = {
            win = {
                position = "float",
                border = "rounded",
                width = 0.8,
                height = 0.8,
            },
        },
    },
    keys = {
        { "<c-\\>", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal", mode = { "n", "t" } },
        { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
        { "<leader>gg", function() Snacks.lazygit.open() end, desc = "Lazygit" },
    },
}
