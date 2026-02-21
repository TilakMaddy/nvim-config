return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        filetypes = {
            javascript = true,
            typescript = true,
            lua = true,
            python = true,
            go = true,
            rust = true,
        },
    },
}
