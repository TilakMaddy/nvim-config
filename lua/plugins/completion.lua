return {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = (function()
                if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
        },
    },
    ---@type table
    opts = {
        snippets = { preset = "luasnip" },
        keymap = {
            preset = "none",
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<Tab>"] = { "select_and_accept", "fallback" },
            ["<C-y>"] = { "select_and_accept", "fallback" },
            ["<C-Space>"] = { "show", "fallback" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<C-l>"] = { "snippet_forward", "fallback" },
            ["<C-h>"] = { "snippet_backward", "fallback" },
        },
        completion = {
            accept = { auto_brackets = { enabled = true } },
            documentation = { auto_show = true },
        },
        sources = {
            default = { "lsp", "snippets", "path", "buffer" },
            per_filetype = {
                lua = { inherit_defaults = true, "lazydev" },
                blade = { inherit_defaults = true, "blade-nav" },
                php = { inherit_defaults = true, "blade-nav" },
            },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                ["blade-nav"] = {
                    name = "Blade",
                    module = "blade-nav.blink",
                },
            },
        },
    },
}
