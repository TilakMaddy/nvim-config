return {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = { "folke/snacks.nvim" },
    config = function()
        vim.g.opencode_opts = {
            provider = {
                snacks = {
                    win = {
                        position = "float",
                        border = "rounded",
                        width = 0.95,
                        height = 0.95,
                    },
                },
            },
        }
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
