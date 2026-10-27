return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require "lint"

        lint.linters_by_ft = {
            python = { "ruff" },
            go = { "golangcilint" },
            terraform = { "tflint" },
        }

        -- Prefer a project-local golangci-lint (e.g. Kubebuilder's custom build with module plugins)
        lint.linters.golangcilint.cmd = function()
            local root = vim.fs.root(0, "go.mod")
            local local_bin = root and vim.fs.joinpath(root, "bin", "golangci-lint")
            if local_bin and vim.fn.executable(local_bin) == 1 then
                return local_bin
            end
            return "golangci-lint"
        end

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
