-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation (explicit 4-space)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Appearance
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 10

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Files
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Mouse & clipboard
vim.opt.mouse = "a"
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Disable netrw (using nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused providers (faster startup)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
