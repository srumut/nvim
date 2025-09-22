vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- line numbers and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- indent size 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- theprimeagen uses a plugin for extended undo capability these are configs for it
vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

-- vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 16
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 300

vim.opt.colorcolumn = "80"
 
