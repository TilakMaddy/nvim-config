-- kj to escape insert mode
vim.keymap.set("i", "kj", "<Esc>")

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>pd", vim.diagnostic.open_float, { desc = "Popup Diagnostics" })

-- Copy file path
vim.keymap.set("n", "<leader>cp", function()
    local path = vim.fn.expand "%:p"
    vim.ui.input({ prompt = "Copy path: ", default = path }, function(val)
        if val and val ~= "" then
            vim.fn.setreg("+", val)
            vim.notify("Copied: " .. val, vim.log.levels.INFO)
        end
    end)
end, { desc = "[C]opy file [P]ath" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
