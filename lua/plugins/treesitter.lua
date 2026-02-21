return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- Register blade filetype for treesitter
        vim.treesitter.language.register("blade", "blade")

        -- Compatibility shims for plugins (telescope, etc.) that use removed
        -- nvim-treesitter APIs (ft_to_lang, is_enabled, get_module, get_parser)
        local parsers = require("nvim-treesitter.parsers")
        if not parsers.ft_to_lang then
            parsers.ft_to_lang = function(ft)
                return vim.treesitter.language.get_lang(ft) or ft
            end
        end
        if not parsers.get_parser then
            parsers.get_parser = function(bufnr, lang)
                return vim.treesitter.get_parser(bufnr, lang)
            end
        end

        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then
            configs = {}
        end
        if not configs.is_enabled then
            configs.is_enabled = function()
                return true
            end
        end
        if not configs.get_module then
            configs.get_module = function()
                return { additional_vim_regex_highlighting = false }
            end
        end

        require("nvim-treesitter").setup({
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
        })
    end,
}
