vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.cursorline = true
vim.opt.compatible = false -- turn off vi compatibility
vim.opt.backup = false -- disable backup
vim.opt.swapfile = false
vim.opt.number = true -- enable line numbers
vim.opt.relativenumber = true -- enable relative line numbers
vim.opt.wrap = false -- disable text wrapping
vim.opt.title = false -- turn of the title
vim.opt.mouse = "a" -- enable mouse on all modes
vim.opt.tabstop = 4 -- tabs are 4 spaces
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
--vim.opt.fileencoding = "utf-8" -- TODO(umut): should I enable this ?
vim.opt.showtabline = 1 -- show tabs only if there are more than one
vim.opt.laststatus = 2 -- always show status line
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.splitright = true -- vertical split to the right
vim.opt.splitbelow = true -- horitzontal split to the below
vim.opt.termguicolors = true
vim.opt.scrolloff = 16 -- verital scroll off
vim.opt.sidescrolloff = 16 -- horizontal scroll off
vim.opt.updatetime = 300
vim.opt.colorcolumn = "" -- ruler column
vim.opt.signcolumn = "no"

-- Idk what does this do, had it in the previous init.lua
--vim.opt.isfname:append("@-@")

vim.opt.syntax = "ON"
vim.cmd("filetype plugin on")

---------------------------- SEARCH -----------------------------------------------
vim.opt.ignorecase = true -- enable case insensetive search
vim.opt.smartcase = true -- case insensetive search unless it is capitalized explicitly
vim.opt.hlsearch = true -- disable search result highlights
vim.opt.incsearch = true -- enable incremental search

--------------------------- FINDING FILES ------------------------------------
-- when searching for a file search through every
-- sub directory recursively
vim.cmd("set path+=**")

-- display all matching files wen tab completing
vim.cmd("set wildmenu")

-- NOW
-- :find command will search for all the subdirectories of the folder nvim runs in / project root
-- you can hit TAB key to complete the file name while using :find to find a file
-- if there are more than one files match with the pattern you used with :find you can navigate between them with TAB (forward) and SHIFT+TAB (backward)

-- ALSO
-- :b lets you open a buffer (basically a file that has been opened in your nvim session) by writing a unique substring for the buffer name
-- for example if you have a buffer with filename tcp_client.c, if you run the command ':b tcp" (and if there is no other buffer has substring tcp)
-- it will open the tcp_client.c without event to TAB complete it (which you can do any time), but this wont work if there are more than one buffer
-- that have the substring "tcp" in that case you either need a more specific substring or just use TAB complete

------------------------- TAG JUMPING ---------------------------------------
-- Create the "tags" files (you may need to install ctags first)
vim.cmd("command! Maketags !ctags -R .")

-- NOW
-- use CTRL+] to jump to tag under cursor
-- use G+CTRL+] for ambigious tags
-- use ^to jump back up in the tags stack


-- BUT
-- this does not help if you want a visual list of tags

------------------------- AUTOCOMPLETE --------------------------------------
-- you should check out the documentation with :help ins-completion

-- SOME OF THEM (check out docs to see other keybindings)
-- CTRL+X+N for just within this file
-- CTRL+X+F for filenames
-- CTRL+X+] for tags only
-- CTRL+N for anything that can be completed

-- NOW
-- you can use CTRL+N and CTRL+P to go forth and back in the suggestion list

vim.opt.pumheight = 10 -- number of items in popup menu
vim.opt.completeopt = {"fuzzy", "noselect", "menuone"}

--------------------------- FILE BROWSING ------------------------------------
-- you should check docs with :help netrw-browse-maps
-- Tweaks for browsing
vim.g.netrw_banner = 1 -- disable the banner
vim.g.netrw_browser_split = 4 -- open in prior window
vim.g.netrw_altv = 1 -- open splits to the right
vim.g.netrw_liststyle = 3 -- tree view

-- NOW 
-- :edit or :Ex a folder to open a file browser
-- hit v to open in a vertical split
-- hit t to open in a tab
-- hit Enter to open in the current window

--------------------------------------------------------------------------

---------------------------- REMAPS -----------------------------------
-- in normal mode leader+P+V key combination runs the command Ex
-- basically opens up the Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Ctrl+K or Ctrl+J go half screen hight distance and also center the screen
vim.keymap.set({"n", "v"}, "<C-j>", "<C-d>zz")
vim.keymap.set({"n", "v"}, "<C-k>", "<C-u>zz")

-- in visual mode you can move the selected lines up with J, down with K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- appends the line below at the end of the line your cursor at, and your
-- cursor does not move
vim.keymap.set("n", "J", "mzJ`z")

-- keeps cursor at the center while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- when you yank some_code and want to past it inplace of another_code_piece
-- after visualizing another_code_pice instead of pressing just p if you press 
-- leader + p it will paste some_code inplace of another_code_pice like just p 
-- would but unlike just p it will not move another_code_piece to the 
-- copy&delete buffer (or whatever it is called) so some_code would be still
-- available paste
vim.keymap.set("x", "<leader>p", "\"_dP")

-- leader+y and Ctrl+C will yank/copy into the system clipboard
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("v", "<C-c>", "\"+y")

-- Ctrl+V will paste into nvim from system clipboard
vim.keymap.set({"n", "v"}, "<C-v>", "\"+p")

-- reload neovim config
if vim.fn.has("win32") == 1 then
    local config_path = vim.fn.expand("~\\AppData\\Local\\nvim\\init.lua")
    vim.keymap.set("n", "<leader>r", string.format(":source %s <CR>", config_path))
elseif vim.fn.has("macunix") == 1 then
    local config_path = vim.fn.expand("$XDG_CONFIG_HOME/nvim/init.lua")
    vim.keymap.set("n", "<leader>r", string.format(":source %s <CR>", config_path))
else
    print("Because OS is not recognized <leader> + r keybinding could not be set")
end

-- new split shorcuts
vim.keymap.set("n", "<leader>v", ":vnew<CR>")
vim.keymap.set("n", "<leader>n", ":new<CR>")
vim.keymap.set("n", "<leader>e", ":vsplit<Cr><C-w>l:Ex<Cr>") -- open netrw in new right split

-- switch to split
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")

vim.keymap.set("n", "<Tab>n", ":bnext <Cr>") -- switch to next buffer
vim.keymap.set("n", "<Tab>p", ":bnext <Cr>") -- switch to previous buffer
vim.keymap.set("n", "<Tab>d", ":bd <Cr>") -- delete the current buffer

vim.keymap.set("n", "<C-l>", ":vertical resize +3<Cr>") -- expand the current split
vim.keymap.set("n", "<C-h>", ":vertical resize -3<Cr>") -- shrink the current split

vim.keymap.set("n", "<C-m>", ":make<CR><CR>:copen<CR>") -- make/build and open quickfix
vim.keymap.set("n", "<C-x>", ":cclose<Cr>") -- make/build and open quickfix
vim.keymap.set("n", "<C-n>", ":cnext<CR>") -- jump to next quickfix list item
vim.keymap.set("n", "<C-p>", ":cprev<CR>") -- jump to previous quickfix list item

-- IMPORTANT(umut): in order this to work you need command 'tee' on your PATH
if vim.fn.has("win32") == 1 then
    vim.opt.makeprg = ".\\shell.bat && .\\build.bat"
elseif vim.fn.has("macunix") == 1 then
    vim.opt.makeprg = "./build.sh"
end

vim.opt.errorformat = {
    "%f(%l)%\\s%\\=:\\ %m", -- MSVC
    "%\\%.%f:%l:%c:\\ %m", -- Clang
    "%-G%.%#" -- Ignore line
}

-- wrap the text inside of quickfix list
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = true
  end,
})

--- COLORSCHEME ---
local colors = {
    background = "#191919",
    default = "#dcdddc",
    comment = "#9e9e9e",
    string = "#8fb76c",
    statement = "#e5d34b",
    type =  "#808585",
    cursor = "#fddd34",
    error_msg = "#963e47",
    warning_msg = "#a98049",
    preproc = "#808585",
    visual = "#393939",
    constant = "#cdad14"
}

vim.opt.guicursor = "n-v-c:block-Cursor,i-ci:ver25-Cursor" -- so that cursor color works properly

local set_color = vim.api.nvim_set_hl
set_color(0, "Normal", {bg = colors.background, fg = colors.default})
set_color(0, "Visual", {bg = colors.visual})
set_color(0, "Comment", {fg = colors.comment})
set_color(0, "String", {fg = colors.string})
set_color(0, "Identifier", {fg = colors.default}) -- any variable name
set_color(0, "Function", {fg = colors.default})
set_color(0, "Constant", {fg = colors.constant})
set_color(0, "Statement", {fg = colors.statement})
set_color(0, "CurSearch", {fg="#bbddbb"}) -- Current match for the search pattern
set_color(0, "IncSearch", {fg="#bbddbb"})
set_color(0, "Substitute", {fg="#bbddbb"})
set_color(0, "Cursor", {bg = colors.cursor, fg = colors.background})
set_color(0, "ErrorMsg", {fg = colors.error_msg})
set_color(0, "WarningMsg", {fg = colors.warning_msg})
set_color(0, "PreProc", {fg = colors.preproc}) -- Preprocessor
set_color(0, "Type", {fg = colors.type})
set_color(0, "StorageClass", {fg = colors.type})
set_color(0, "Structure", {fg = colors.type})
set_color(0, "Typedef", {fg = colors.type})
set_color(0, "Special", {fg = colors.default})

set_color(0, "Todo", {fg="#cc2222", bold=true, underline=true}) 

vim.api.nvim_create_namespace("note")
vim.fn.matchadd("note", "NOTE")
set_color(0, "note", {fg="#22cc22", bold=true, underline=true})

vim.api.nvim_create_namespace("important")
vim.fn.matchadd("important", "IMPORTANT")
set_color(0, "important", {fg="#cccc22", bold=true, underline=true})

--############## NEOVIDE ################################
if vim.g.neovide then
    vim.o.guifont = "Liberation Mono:h10"

    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00

    vim.keymap.set("n", "<F11>", function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end)
end
--#####################################################

--###### FTERMINAL ########################
-- https://youtu.be/5PIiKDES_wc
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = "rounded",
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
        vim.cmd("startinsert!")
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Fterminal", toggle_terminal, {})
vim.keymap.set({"n", "t"}, "<leader>t", toggle_terminal)

