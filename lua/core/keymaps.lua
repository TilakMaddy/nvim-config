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

-- Pull first word of next line up to the end of the current line
vim.keymap.set("n", "gK", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, row - 1, row + 1, false)
    if #lines < 2 then
        return
    end
    local indent, word, rest = lines[2]:match "^(%s*)(%S+)%s*(.*)$"
    if not word then
        return
    end
    local cur = lines[1]:gsub("%s+$", "")
    vim.api.nvim_buf_set_lines(0, row - 1, row + 1, false, { cur .. " " .. word, indent .. rest })
end, { desc = "Pull first word of next line up" })

-- Push last word of current line down to the start of the next line
vim.keymap.set("n", "gL", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, row - 1, row + 1, false)
    local head, word = lines[1]:match "^(.-)%s*(%S+)%s*$"
    if not word then
        return
    end
    local next_line = lines[2] or ""
    local indent, rest = next_line:match "^(%s*)(.-)$"
    if rest == "" then
        indent = lines[1]:match "^%s*"
    end
    local new_next = indent .. word .. (rest ~= "" and " " .. rest or "")
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1 + #lines, false, { head, new_next })
end, { desc = "Push last word of current line down" })
