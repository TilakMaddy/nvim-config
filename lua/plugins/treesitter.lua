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

        -- main branch: install() is async and skips already-installed parsers
        require("nvim-treesitter").install {
            "bash",
            "c",
            "cpp",
            "css",
            "diff",
            "elixir",
            "go",
            "hcl",
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
            "terraform",
            "typescript",
            "vim",
            "vimdoc",
        }

        -- main branch has no highlight/indent modules; start treesitter per buffer
        local function start(buf)
            if pcall(vim.treesitter.start, buf) then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        -- main branch also dropped auto_install; install missing parsers on first use
        local available = {}
        for _, lang in ipairs(require("nvim-treesitter").get_available()) do
            available[lang] = true
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if lang and available[lang] and not vim.list_contains(require("nvim-treesitter").get_installed "parsers", lang) then
                    require("nvim-treesitter").install(lang):await(function(err)
                        if err then
                            return
                        end
                        vim.schedule(function()
                            if vim.api.nvim_buf_is_valid(args.buf) then
                                start(args.buf)
                            end
                        end)
                    end)
                    return
                end
                start(args.buf)
            end,
        })

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
