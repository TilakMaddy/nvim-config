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
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e", "<cmd>Neotree float reveal<cr>", desc = "Float file tree" },
        },
        opts = {
            popup_border_style = "rounded",
            window = {
                position = "float",
                popup = {
                    size = { width = "100%", height = "100%" },
                },
                mappings = {
                    ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
                    ["l"] = "open",
                    ["h"] = "close_node",
                },
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        ".git",
                    },
                },
                follow_current_file = { enabled = true },
                window = {
                    mappings = {
                        ["O"] = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            path = vim.fn.fnamemodify(path, ":h")
                            vim.fn.system({ "open", path })
                        end,
                        ["H"] = "toggle_hidden",
                        ["I"] = function(state)
                            local fi = state.filtered_items
                            fi.hide_gitignored = not fi.hide_gitignored
                            require("neo-tree.sources.manager").refresh("filesystem")
                        end,
                    },
                },
            },
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
