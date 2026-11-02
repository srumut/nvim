-- lua/config/options.lua -- editor options (vim.opt / vim.g). No keymaps, no autocmds.
local opt = vim.opt

---------------------------- GENERAL -----------------------------------------------
opt.cursorline = true
opt.backup = false -- disable backup
opt.swapfile = false
opt.number = true -- enable line numbers
opt.relativenumber = false -- disable relative line numbers
opt.wrap = false -- disable text wrapping
opt.title = false -- turn of the title
opt.mouse = "a" -- enable mouse on all modes
opt.tabstop = 4 -- tabs are 4 spaces
opt.softtabstop = 4
opt.shiftwidth = 4
--opt.fileencoding = "utf-8" -- TODO(umut): should I enable this ?
opt.showtabline = 1 -- show tabs only if there are more than one
opt.laststatus = 2 -- always show status line
opt.expandtab = true
opt.smartindent = true
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- horitzontal split to the below
opt.termguicolors = true
opt.scrolloff = 16 -- verital scroll off
--opt.sidescrolloff = 16 -- horizontal scroll off
opt.updatetime = 300
opt.colorcolumn = "" -- ruler column
opt.signcolumn = "no"

-- Idk what does this do, had it in the previous init.lua
--opt.isfname:append("@-@")

---------------------------- SEARCH -----------------------------------------------
opt.ignorecase = false -- search is case-sensitive
opt.smartcase = true -- only has an effect while 'ignorecase' is on (so currently inert)
opt.hlsearch = true -- highlight search results
opt.incsearch = true -- enable incremental search

--------------------------- FINDING FILES ------------------------------------
-- when searching for a file search through every
-- sub directory recursively
opt.path:append("**")

-- NOW
-- :find command will search for all the subdirectories of the folder nvim runs in / project root
-- you can hit TAB key to complete the file name while using :find to find a file
-- if there are more than one files match with the pattern you used with :find you can navigate between them with TAB (forward) and SHIFT+TAB (backward)

-- ALSO
-- :b lets you open a buffer (basically a file that has been opened in your nvim session) by writing a unique substring for the buffer name
-- for example if you have a buffer with filename tcp_client.c, if you run the command ':b tcp" (and if there is no other buffer has substring tcp)
-- it will open the tcp_client.c without event to TAB complete it (which you can do any time), but this wont work if there are more than one buffer
-- that have the substring "tcp" in that case you either need a more specific substring or just use TAB complete

------------------------- AUTOCOMPLETE --------------------------------------
-- you should check out the documentation with :help ins-completion

-- SOME OF THEM (check out docs to see other keybindings)
-- CTRL+X+N for just within this file
-- CTRL+X+F for filenames
-- CTRL+X+] for tags only
-- CTRL+N for anything that can be completed

-- NOW
-- you can use CTRL+N and CTRL+P to go forth and back in the suggestion list

opt.pumheight = 10 -- number of items in popup menu
opt.completeopt = { "fuzzy", "noselect", "menuone" }

--------------------------- FILE BROWSING ------------------------------------
-- you should check docs with :help netrw-browse-maps
-- Tweaks for browsing
vim.g.netrw_banner = 1 -- show the banner (0 hides it)
vim.g.netrw_browser_split = 4 -- open in prior window
vim.g.netrw_altv = 1 -- open splits to the right
vim.g.netrw_liststyle = 1 -- long listing (0 thin, 1 long, 2 wide, 3 tree)

-- NOW
-- :edit or :Ex a folder to open a file browser
-- hit v to open in a vertical split
-- hit t to open in a tab
-- hit Enter to open in the current window

--------------------------- QUICKFIX ------------------------------------
opt.errorformat = {
    "%f(%l)%\\s%\\=:\\ %m", -- MSVC source code error
    "c1: %m",               -- MSVC compiler error
    "LINK : %m",            -- MSVC linker error
    "%\\%.%f:%l:%c:\\ %m",  -- Clang
    "error: %m",            -- Clang compiler error
    "clang: error: %m",     -- Clang error
    "%f: line %l: %m",      -- build script error
    "%-G%.%#",              -- Ignore line
}
