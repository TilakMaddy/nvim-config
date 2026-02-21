return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
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
            },
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            render = "virtual",
            enable_tailwind = false,
        },
    },
}
