return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require "lint"

        lint.linters_by_ft = {
            python = { "ruff" },
            go = { "golangcilint" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
            group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
            callback = function()
                if vim.bo.buftype == "" then
                    lint.try_lint()
                end
            end,
        })
    end,
}
