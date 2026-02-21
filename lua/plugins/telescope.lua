return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerd_font },
    },
    keys = {
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
        { "<leader>saf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [A]ll [F]iles" },
        { "<leader>sf", "<cmd>Telescope git_files<cr>", desc = "[S]earch Git [F]iles" },
        { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect Telescope" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
        { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
        { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
        { "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)' },
        { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                -- Performance: use fd and ripgrep, skip heavy files
                file_ignore_patterns = {
                    "node_modules/",
                    ".git/",
                    "%.lock",
                    "dist/",
                    "build/",
                    "target/",
                    "vendor/",
                    "%.min%.js",
                },
                -- Faster sorting
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                },
                -- Limit results for speed
                path_display = { "truncate" },
                preview = {
                    filesize_limit = 1, -- skip previewing files > 1MB
                    timeout = 250,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })

        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        -- These keymaps need function wrappers so they stay here
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })

        vim.keymap.set("n", "<leader>s/", function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end, { desc = "[S]earch [/] in Open Files" })

        vim.keymap.set("n", "<leader>sn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim files" })
    end,
}
