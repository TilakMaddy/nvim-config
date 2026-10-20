-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Make Go respect gofmt/tab indentation instead of the global expandtab setting
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 0
    end,
})

-- Blade filetype detection
vim.api.nvim_create_augroup("BladeFiletypeRelated", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.blade.php",
    group = "BladeFiletypeRelated",
    callback = function()
        vim.bo.filetype = "blade"
    end,
})
