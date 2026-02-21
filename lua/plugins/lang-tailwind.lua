return {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    ft = {
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
        "vue",
        "php",
        "blade",
        "elixir",
        "heex",
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
        -- Suppress the lspconfig deprecation warning from tailwind-tools
        -- (known issue: https://github.com/luckasRanarison/tailwind-tools.nvim/issues/80)
        local orig_deprecate = vim.deprecate
        vim.deprecate = function() end
        require("tailwind-tools").setup(opts)
        vim.deprecate = orig_deprecate
    end,
}
