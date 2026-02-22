return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        -- Register blade filetype for treesitter
        vim.treesitter.language.register("blade", "blade")

        -- Compatibility shim for blade-nav.nvim which uses the removed get_parser API
        local parsers = require "nvim-treesitter.parsers"
        if not parsers.get_parser then
            parsers.get_parser = function(bufnr, lang)
                return vim.treesitter.get_parser(bufnr, lang)
            end
        end

        require("nvim-treesitter").setup {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "diff",
                "elixir",
                "go",
                "html",
                "javascript",
                "json",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "php",
                "python",
                "query",
                "rust",
                "svelte",
                "typescript",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        }

        -- Textobjects config (standalone plugin, not via nvim-treesitter.setup)
        require("nvim-treesitter-textobjects").setup {
            select = { lookahead = true },
        }

        local select = require "nvim-treesitter-textobjects.select"
        local move = require "nvim-treesitter-textobjects.move"
        local swap = require "nvim-treesitter-textobjects.swap"

        -- Select textobjects
        local select_maps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
        }
        for key, query in pairs(select_maps) do
            vim.keymap.set({ "x", "o" }, key, function()
                select.select_textobject(query)
            end, { desc = "TS: " .. query })
        end

        -- Move to next/prev
        local move_maps = {
            ["]f"] = { fn = move.goto_next_start, q = "@function.outer", desc = "Next function" },
            ["[f"] = { fn = move.goto_previous_start, q = "@function.outer", desc = "Prev function" },
            ["]c"] = { fn = move.goto_next_start, q = "@class.outer", desc = "Next class" },
            ["[c"] = { fn = move.goto_previous_start, q = "@class.outer", desc = "Prev class" },
            ["]a"] = { fn = move.goto_next_start, q = "@parameter.inner", desc = "Next argument" },
            ["[a"] = { fn = move.goto_previous_start, q = "@parameter.inner", desc = "Prev argument" },
        }
        for key, m in pairs(move_maps) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
                m.fn(m.q)
            end, { desc = m.desc })
        end

        -- Swap arguments
        vim.keymap.set("n", "<leader>xa", function()
            swap.swap_next "@parameter.inner"
        end, { desc = "Swap with next argument" })
        vim.keymap.set("n", "<leader>xA", function()
            swap.swap_previous "@parameter.inner"
        end, { desc = "Swap with prev argument" })
    end,
}
