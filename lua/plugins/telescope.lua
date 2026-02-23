return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable "make" == 1
            end,
        },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerd_font },
        { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    keys = {
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
        { "<leader>saf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [A]ll [F]iles" },
        { "<leader>sf", "<cmd>Telescope git_files<cr>", desc = "[S]earch Git [F]iles" },
        { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect Telescope" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
        {
            "<leader>sg",
            function()
                require("telescope").extensions.live_grep_args.live_grep_args()
            end,
            desc = "[S]earch by [G]rep (with args)",
        },
        {
            "<leader>sG",
            function()
                require("telescope.builtin").live_grep { additional_args = { "--no-ignore", "--hidden" } }
            end,
            desc = "[S]earch by Grep (include ignored/hidden)",
        },
        {
            "<leader>sD",
            function()
                vim.ui.input({ prompt = "Directory: " }, function(dir)
                    if dir and dir ~= "" then
                        require("telescope").extensions.live_grep_args.live_grep_args { search_dirs = { dir } }
                    end
                end)
            end,
            desc = "[S]earch [D]irectory (scoped grep)",
        },
        {
            "<leader>sd",
            function()
                require("telescope.builtin").diagnostics {
                    layout_strategy = "vertical",
                    layout_config = { width = 0.95, height = 0.95, preview_height = 0.4 },
                }
            end,
            desc = "[S]earch [D]iagnostics",
        },
        { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
        { "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)' },
        { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
    },
    config = function()
        require("telescope").setup {
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
                live_grep_args = {
                    auto_quoting = true,
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                            ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt { postfix = " --iglob " },
                            ["<C-t>"] = require("telescope-live-grep-args.actions").quote_prompt { postfix = " -t " },
                        },
                    },
                },
            },
        }

        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "live_grep_args")
        -- These keymaps need function wrappers so they stay here
        local builtin = require "telescope.builtin"
        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = "[/] Fuzzily search in current buffer" })

        vim.keymap.set("n", "<leader>s/", function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            }
        end, { desc = "[S]earch [/] in Open Files" })

        vim.keymap.set("n", "<leader>sn", function()
            builtin.find_files { cwd = vim.fn.stdpath "config" }
        end, { desc = "[S]earch [N]eovim files" })

        vim.keymap.set("n", "<leader>sF", function()
            vim.cmd 'let g:_telescope_dir = input("Directory: ", "", "dir")'
            local dir = vim.g._telescope_dir
            vim.g._telescope_dir = nil
            if dir and dir ~= "" then
                builtin.find_files { cwd = dir, prompt_title = "Find Files in " .. dir }
            end
        end, { desc = "[S]earch [F]iles in directory" })
    end,
}
