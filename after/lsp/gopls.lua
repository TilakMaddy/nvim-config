return {
    settings = {
        gopls = {
            -- Formatting
            gofumpt = true,

            -- Completion
            usePlaceholders = true,
            completeUnimported = true,
            matcher = "Fuzzy",

            -- Diagnostics / analysis
            staticcheck = true,
            vulncheck = "Imports",
            analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedvariable = true,
                unusedwrite = true,
                useany = true,
            },

            -- UI
            semanticTokens = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            codelenses = {
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },

            directoryFilters = { "-.git", "-node_modules", "-vendor" },
        },
    },
    on_attach = function(client, bufnr)
        -- gopls formatting doesn't touch imports; organize them on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("gopls-organize-imports-" .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
                local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
                params.context = { only = { "source.organizeImports" }, diagnostics = {} }
                local res = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
                for _, action in ipairs(res and res.result or {}) do
                    if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                    end
                end
            end,
        })

        -- Code lenses: "run test", "go mod tidy", "check for upgrades", ...
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
        vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, desc = "LSP: Run [C]ode[L]ens" })
    end,
}
