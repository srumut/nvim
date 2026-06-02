-- treesitter parse directory path relative to the this files directory
local treesitter_parser_dir = vim.fn.stdpath('data') .. '/treesitter_parsers'
-- add ts parser directory to the neovim runtime path
vim.opt.rtp:append(treesitter_parser_dir)

local treesitter_languages = {"c", "cpp", "lua", "python", "go", "html"}
local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok then
    ts_configs.setup({
        install_dir = treesitter_parser_dir,
        ensure_installed = treesitter_languages,
        highlight = { enable = true },
    })
end
vim.api.nvim_create_autocmd('FileType', {
  pattern = treesitter_languages,
  callback = function() vim.treesitter.start() end,
})

-- TODO(umut): maybe comment this on machines that I dont use 
vim.g.go_auto_update_tools = 0

--vim.o.background = "dark"
--vim.cmd([[colorscheme gruvbox]])

--vim.cmd([[colorscheme kanagawa-dragon]])

--vim.cmd([[colorscheme nightfox]])
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox-material]])


-- if the path passed to neovim is a directory make that directory neovims root (run neovim
-- inside that directory, if given is a file than make root that file's parent directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "" then
      return
    end

    -- make absolute path
    local full = vim.fn.fnamemodify(arg, ":p")
    local stat = vim.loop.fs_stat(full)

    local root

    if stat and stat.type == "directory" then
      -- argument is existing directory
      root = full
      vim.cmd("lcd " .. vim.fn.fnameescape(root))

    else
      -- file OR non-existing file
      root = vim.fn.fnamemodify(full, ":h")
      vim.cmd("lcd " .. vim.fn.fnameescape(root))
    end
  end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.cursorline = true
vim.opt.compatible = false -- turn off vi compatibility
vim.opt.backup = false -- disable backup
vim.opt.swapfile = false
vim.opt.number = true -- enable line numbers
vim.opt.relativenumber = false -- disable relative line numbers
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
--vim.opt.sidescrolloff = 16 -- horizontal scroll off
vim.opt.updatetime = 300
vim.opt.colorcolumn = "" -- ruler column
vim.opt.signcolumn = "no"
local os = vim.loop.os_uname().sysname
if os == "Darwin" then
    vim.o.guifont = "Liberation Mono:h13"
else
    vim.o.guifont = "Liberation Mono:h10"
end

-- Idk what does this do, had it in the previous init.lua
--vim.opt.isfname:append("@-@")

vim.opt.syntax = "ON"
vim.cmd("filetype plugin on")

---------------------------- SEARCH -----------------------------------------------
vim.opt.ignorecase = false -- disable case insensetive search
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

------------------------- DYNAMIC FONT RESIZING ON NEOVIDE ---------------------------------------
local function neovideScale(amount)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + amount
end

vim.keymap.set('n', '<C-+>', function() neovideScale(0.1) end)
vim.keymap.set('n', '<C-->', function() neovideScale(-0.1) end)
vim.keymap.set('n', '<C-0>', function() vim.g.neovide_scale_factor = 1 end)

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


---------------------------- UTILITIES -----------------------------------
local function exists(path)
  return vim.loop.fs_stat(path) ~= nil
end

-- TODO(umut): improve and use
local function replace()
    local old_word = vim.fn.input("replace: ")
    if old_word == "" then
        print("word can't be empty")
        return
    end
    local new_word = vim.fn.input("with: ")
    if new_word ~= old_word then
        local cmd_str = ":"
        if vim.api.nvim_get_mode()["mode"] == "v" then
            cmd_str = ":'<,'>"
        end
        cmd_str = cmd_str .. "s/" .. old_word .. "/" .. new_word .. "/g"
        vim.cmd(cmd_str)
    end
end

-- TODO(umut): this is probably should not be in this section
-- this auto commands ensure splits are evenly distributed when window resizes
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    -- your logic here, e.g. equalize split sizes
    vim.cmd("wincmd =")
  end
})

---------------------------- REMAPS -----------------------------------
-- in normal mode leader+P+V key combination runs the command Ex
-- basically opens up the Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Ctrl+K or Ctrl+J go half screen hight distance and also center the screen
vim.keymap.set({"n", "v"}, "<C-j>", "<C-d>zz")
vim.keymap.set({"n", "v"}, "<C-k>", "<C-u>zz")

-- go end of the file also center the screen
vim.keymap.set({"n", "v"}, "G", "Gzz")

-- in visual mode you can move the selected lines up with J, down with K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- appends the line below at the end of the line your cursor at, and your
-- cursor does not move
vim.keymap.set("n", "J", "mzJ`z")

-- keeps cursor at the center while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- a function to open the definition of the tag in the other window
local function tag_in_other_window()
    local tag = vim.fn.expand("<cword>")
    if tag == "" then
        print("No tag under cursor")
        return
    end

    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins < 2 then
        print("Need two splits")
        return
    end

    local current = vim.api.nvim_get_current_win()
    local target
    for _, w in ipairs(wins) do
        if w ~= current then
            target = w
            break
        end
    end
    if not target then return end

    -- Escape single quotes for a single-quoted Vimscript string used in execute()
    local tag_escaped = tag:gsub("'", "''")
    print(tag_escaped)

    vim.api.nvim_win_call(target, function()
        -- use execute so tags that contain spaces are handled as a single argument
        vim.cmd(('tag %s'):format(tag_escaped))
    end)

    vim.api.nvim_set_current_win(target)
end


-- tag jumping remaps
if os == "Darwin" then
    vim.keymap.set("n", "<D-g>", "<C-]>", { silent = true })
    vim.keymap.set("n", "<D-w>", tag_in_other_window, { silent = true })
    vim.keymap.set("n", "<D-b>", "<C-t>", { silent = true })
else
    vim.keymap.set("n", "<A-g>", "<C-]>", { silent = true })
    vim.keymap.set("n", "<A-w>", tag_in_other_window, { silent = true })
    vim.keymap.set("n", "<A-b>", "<C-t>", { silent = true })
end

-- this (ambiguous tag jumping remap)  does not seem to be working
--vim.keymap.set("n", "<A-a>", "<C-g-]>", { silent = true })
-- create tags by pressing Alt+t
vim.keymap.set("n", "<A-t>", function()
    dir_present = exists("./src")
    if not dir_present then
        print("Error: src folder doesn't exist")
        return
    end
    status = os.execute("ctags -R src")
    if status == 0 then
        print("Tags created successfuly")
    else
        print("Error: tags couldn't be created (shell might not be accessible, or some other reason)")
    end
end)

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
vim.keymap.set("n", "<Tab>p", ":bprevious <Cr>") -- switch to previous buffer
vim.keymap.set("n", "<Tab>d", ":bd <Cr>") -- delete the current buffer

vim.keymap.set("n", "<C-l>", ":vertical resize +3<Cr>") -- expand the current split
vim.keymap.set("n", "<C-h>", ":vertical resize -3<Cr>") -- shrink the current split

vim.keymap.set("n", "<C-m>", ":make<CR><CR>:copen<CR>") -- make/build and open quickfix
vim.keymap.set("n", "<C-x>", ":cclose<Cr>") -- make/build and open quickfix
vim.keymap.set("n", "<C-n>", ":cnext<CR>") -- jump to next quickfix list item
vim.keymap.set("n", "<C-p>", ":cprev<CR>") -- jump to previous quickfix list item

-- TODO(umut): redundant?
vim.keymap.set("n", "<C-a>", function() print(vim.api.nvim_tabpage_list_wins(0)) end)


local ensure_two_slits_group = vim.api.nvim_create_augroup("EnsureTwoVerticalSplits", { clear = true })
local function ensure_two_splits()
    -- only create splits if there's only one window
    if #vim.api.nvim_tabpage_list_wins(0) == 1 then
        vim.cmd("vsplit")
    end
end
-- Automatically create 2 horizontal splits in new tabs
vim.api.nvim_create_autocmd("TabNewEntered", {
    group = ensure_two_slits_group,
    callback = ensure_two_splits,
})
-- Automatically create 2 horizontal splits in new tabs
vim.api.nvim_create_autocmd("VimEnter", {
    group = ensure_two_slits_group,
    callback = ensure_two_splits,
})

-- open buffer in other split
local function open_in_other_split(bufnr)
    -- Get all windows in current tab
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins < 2 then
        print("Need at least two splits")
        return
    end

    local current = vim.api.nvim_get_current_win()
    local target_win

    -- Find the other window
    for _, w in ipairs(wins) do
        if w ~= current then
            target_win = w
            break
        end
    end

    if not target_win then
        print("No other window found")
        return
    end

    -- Set the buffer in the other window
    vim.api.nvim_win_set_buf(target_win, bufnr)
    -- Optional: move cursor there
    vim.api.nvim_set_current_win(target_win)
end

local function get_pair_targets()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then return end

    local ext = path:match("^.+(%..+)$")
    local base = path:match("(.+)%..+$")
    if not ext or not base then return end

    -- Table of alternate extensions
    local targets = {}

    if ext == ".c" or ext == ".m" then
        table.insert(targets, base .. ".h")
    elseif ext == ".cpp" or ext == ".cc" or ext == ".mm" then
        table.insert(targets, base .. ".h")
        table.insert(targets, base .. ".hpp")
    elseif ext == ".h" then
        -- header → try sources in C/C++/ObjC/ObjC++
        table.insert(targets, base .. ".cpp")
        table.insert(targets, base .. ".cc")
        table.insert(targets, base .. ".c")
        table.insert(targets, base .. ".m")
        table.insert(targets, base .. ".mm")
    elseif ext == ".hpp" then
        table.insert(targets, base .. ".cpp")
        table.insert(targets, base .. ".cc")
        table.insert(targets, base .. ".mm")
    else
        print("Not a recognized source/header file")
        return
    end

    return targets
end

-- Toggle between source/header for C/C++/Objective-C/Objective-C++
vim.keymap.set("n", "<C-c>", function()
    targets = get_pair_targets()
    for _, f in ipairs(targets) do
        if vim.fn.filereadable(f) == 1 then
            vim.cmd("edit " .. f)
            return
        end
    end
    print("No matching file found")
end)

-- Open corresponding source/header file in the other split
vim.keymap.set("n", "<C-S-c>", function()
    targets = get_pair_targets()
    for _, f in ipairs(targets) do
        if vim.fn.filereadable(f) == 1 then
            local bufnr = vim.fn.bufadd(f)
            vim.fn.bufload(bufnr)
            open_in_other_split(bufnr)
            return
        end
    end
    print("No matching file found")
end)


local header_group = vim.api.nvim_create_augroup("CppHeaderGuards", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
    group = header_group,
    pattern = { "*.h", "*.hpp" },
    callback = function()
        local name = vim.fn.expand("%:t:r"):upper()
        local guard = name:gsub("%W", "_") .. "_" .. vim.fn.expand("%:e"):upper()

        vim.fn.append(0, {"#if !defined(" .. guard .. ")"})
        vim.fn.append(1, {""})
        vim.fn.append(2, {""})
        vim.fn.append(3, {""})
        vim.fn.append(4, {""})
        vim.fn.append(5, {""})
        vim.fn.append(6, {"#define " .. guard})
        vim.fn.append(7, {"#endif"})
        vim.cmd("normal! 4G")
    end,
})

-- IMPORTANT(umut): in order this to work you need command 'tee' on your PATH
if vim.fn.has("win32") == 1 then
    vim.opt.makeprg = ".\\shell.bat && .\\build.bat"
elseif vim.fn.has("macunix") == 1 then
    vim.opt.makeprg = "./build.sh"
end

vim.opt.errorformat = {
    "%f(%l)%\\s%\\=:\\ %m", -- MSVC source code error
    "c1: %m",               -- MSVC compiler error
    "LINK : %m",            -- MSVC linker error
    "%\\%.%f:%l:%c:\\ %m",  -- Clang
    "error: %m",            -- Clang compiler error
    "clang: error: %m",     -- Clang error
    "%f: line %l: %m",    -- build.sh script error
    "%-G%.%#"               -- Ignore line
}

-- wrap the text inside of quickfix list
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.wrap = true
    end,
})

--- COLORSCHEME ---
local set_color = vim.api.nvim_set_hl

-- this does not work with my current colorscheme (probably can make it work, by colorscheme config but I won't)
-- set_color(0, "Todo", {fg="#cc2222", bold=true, underline=true}) 

vim.api.nvim_create_namespace("Todo")
vim.fn.matchadd("Todo", "TODO")
set_color(0, "Todo", {fg="#ff2222", bold=true, underline=true})

vim.api.nvim_create_namespace("Note")
vim.fn.matchadd("Note", "NOTE")
set_color(0, "Note", {fg="#22cc22", bold=true, underline=true})

vim.api.nvim_create_namespace("Important")
vim.fn.matchadd("Important", "IMPORTANT")
set_color(0, "Important", {fg="#cccc22", bold=true, underline=true})

--[[
local colors = {
    background = "#191919",
    default = "#dcdddc",
    comment = "#9e9e9e",
    string = "#8fb76c",
    statement = "#e5d34b",
    type =  "#808585",
    cursor = "#fddd34",
    error_msg = "#ff3e47",
    warning_msg = "#a98049",
    preproc = "#808585",
    visual = "#393939",
    constant = "#cdad14"
}

vim.opt.guicursor = "n-v-c:block-Cursor,i-ci:ver25-Cursor" -- so that cursor color works properly

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
set_color(0, "QuickFixLine", {fg = colors.error_msg})

]]--

--############## NEOVIDE ################################
if vim.g.neovide then
    -- vim.o.guifont = "Liberation Mono:h10"

    --vim.g.neovide_position_animation_length = 0
    --vim.g.neovide_cursor_animation_length = 0.00
    --vim.g.neovide_cursor_trail_size = 0
    --vim.g.neovide_cursor_animate_in_insert_mode = false
    --vim.g.neovide_cursor_animate_command_line = false
    --vim.g.neovide_scroll_animation_far_lines = 0
    --vim.g.neovide_scroll_animation_length = 0.00

    vim.g.neovide_hide_mouse_when_typing = true

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
vim.keymap.set({"n", "t"}, "<C-t>", toggle_terminal)

