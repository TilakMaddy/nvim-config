return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {
            style = "night",
            on_highlights = function(hl, _)
                hl.Comment = { fg = "orange" }
            end,
        },
        init = function()
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
        keys = {
            {
                "<leader>tt",
                function()
                    require("telescope.builtin").colorscheme({ enable_preview = true })
                end,
                desc = "[T]oggle [T]heme (picker)",
            },
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            no_italic = true,
        },
    },
    {
        "projekt0n/github-nvim-theme",
        config = function()
            require("github-theme").setup({})
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            disable_italics = true,
        },
    },
    {
        "rebelot/kanagawa.nvim",
        opts = {
            compile = true,
            commentStyle = { italic = false },
            keywordStyle = { italic = false },
        },
    },
    {
        "sainnhe/everforest",
        init = function()
            vim.g.everforest_disable_italic_comment = 1
        end,
    },
}
