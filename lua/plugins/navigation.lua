return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
        keys = {
            { "<leader>fj", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
            { "<leader>ff", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            sort = { sorter = "case_sensitive" },
            view = { width = 30 },
            renderer = { group_empty = true },
            filters = { dotfiles = true },
        },
    },
    {
        "cbochs/grapple.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            scope = "git",
            quick_select = "123456789",
        },
        keys = {
            { "<leader>ha", "<cmd>Grapple toggle<cr>", desc = "[G]rapple: [A]dd/Toggle" },
            { "<leader>hf", "<cmd>Grapple toggle_tags<cr>", desc = "[G]rapple [F]ind Tags" },
            { "<c-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: Next" },
            { "<c-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple: Previous" },
        },
    },
}
