return {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local elixir = require "elixir"
        local elixirls = require "elixir.elixirls"

        elixir.setup {
            nextls = { enable = true },
            elixirls = {
                enable = true,
                settings = elixirls.settings {
                    dialyzerEnabled = false,
                    enableTestLenses = false,
                },
                on_attach = function(_, _)
                    vim.keymap.set("n", "<leader>exp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                    vim.keymap.set("n", "<leader>exo", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                    vim.keymap.set("v", "<leader>exm", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
                end,
            },
            projectionist = { enable = true },
        }
    end,
}
