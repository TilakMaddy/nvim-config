local theme_file = vim.fn.stdpath("data") .. "/theme.txt"

local function load_saved_theme()
    local f = io.open(theme_file, "r")
    if f then
        local theme = f:read("*l")
        f:close()
        if theme and theme ~= "" then
            return theme
        end
    end
    return "catppuccin-mocha"
end

local function save_theme(name)
    local f = io.open(theme_file, "w")
    if f then
        f:write(name)
        f:close()
    end
end

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
            vim.cmd.colorscheme(load_saved_theme())
        end,
        keys = {
            {
                "<leader>tt",
                function()
                    require("telescope.builtin").colorscheme({
                        enable_preview = true,
                        attach_mappings = function(_, map)
                            map("i", "<CR>", function(prompt_bufnr)
                                local selection = require("telescope.actions.state").get_selected_entry()
                                require("telescope.actions").close(prompt_bufnr)
                                if selection then
                                    vim.cmd.colorscheme(selection.value)
                                    save_theme(selection.value)
                                    vim.notify("Theme saved: " .. selection.value)
                                end
                            end)
                            return true
                        end,
                    })
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
