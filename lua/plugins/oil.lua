return {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
    },
    opts = {
        default_file_explorer = false,
        view_options = {
            show_hidden = true,
        },
        float = {
            padding = 4,
            max_width = 120,
            max_height = 40,
        },
        keymaps = {
            ["q"] = "actions.close",
            ["<C-s>"] = false, -- don't override split
        },
    },
}
