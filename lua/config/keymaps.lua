-- lua/config/keymaps.lua -- EVERY shared key combo lives here, grouped by topic.

local tags = require("config.features.tags")
local source_header = require("config.features.source_header")
local terminal = require("config.features.terminal")

local function map(mode, lhs, rhs, desc, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {}))
end

---------------------------- FILE FINDER (fff) ------------------------------
map("n", "<leader>ff", function() require("fff").find_files() end, "FFF: Find files")
map("n", "<leader>fg", function() require("fff").live_grep() end, "FFF: Live grep")
map({ "n", "x" }, "<leader>fw", function() require("fff").live_grep_under_cursor() end, "FFF: Grep word/selection")

---------------------------- MOVEMENT ---------------------------------------
-- in normal mode leader+P+V key combination runs the command Ex
-- basically opens up the Explorer
map("n", "<leader>pv", vim.cmd.Ex, "Open explorer (netrw)")

-- Ctrl+K or Ctrl+J go half screen hight distance and also center the screen
map({ "n", "v" }, "<C-j>", "<C-d>zz", "Half page down, centered")
map({ "n", "v" }, "<C-k>", "<C-u>zz", "Half page up, centered")

-- go end of the file also center the screen
map({ "n", "v" }, "G", "Gzz", "End of file, centered")

-- keeps cursor at the center while searching
map("n", "n", "nzzzv", "Next search result, centered")
map("n", "N", "Nzzzv", "Previous search result, centered")

---------------------------- EDITING ----------------------------------------
-- in visual mode you can move the selected lines up with J, down with K
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- appends the line below at the end of the line your cursor at, and your
-- cursor does not move
map("n", "J", "mzJ`z", "Join line below, cursor stays")

-- when you yank some_code and want to past it inplace of another_code_piece
-- after visualizing another_code_pice instead of pressing just p if you press
-- leader + p it will paste some_code inplace of another_code_pice like just p
-- would but unlike just p it will not move another_code_piece to the
-- copy&delete buffer (or whatever it is called) so some_code would be still
-- available paste
map("x", "<leader>p", "\"_dP", "Paste over selection, keep register")

-- leader+y and Ctrl+C will yank/copy into the system clipboard
map("v", "<leader>y", "\"+y", "Yank to system clipboard")
map("v", "<C-c>", "\"+y", "Yank to system clipboard")
-- Ctrl+V will paste into nvim from system clipboard
map({ "n", "v" }, "<C-v>", "\"+p", "Paste from system clipboard")

---------------------------- TABS -------------------------------------------
map("n", "<C-1>", "1gt", "Go to tab 1")
map("n", "<C-2>", "2gt", "Go to tab 2")
map("n", "<C-3>", "3gt", "Go to tab 3")
map("n", "<C-4>", "4gt", "Go to tab 4")
map("n", "<C-5>", "5gt", "Go to tab 5")
map("n", "<C-6>", "6gt", "Go to tab 6")
map("n", "<C-7>", "7gt", "Go to tab 7")
map("n", "<C-8>", "8gt", "Go to tab 8")
map("n", "<C-9>", ":tablast<CR>", "Go to last tab")
map("n", "<leader>w", "<Cmd>tabclose<CR>", "Close tab")
map("n", "<leader>t", ":tabnew<CR>", "New tab")

---------------------------- SPLITS -----------------------------------------
-- new split shorcuts
map("n", "<leader>v", ":vnew<CR>", "New vertical split")
map("n", "<leader>n", ":new<CR>", "New horizontal split")
map("n", "<leader>e", ":vsplit<Cr><C-w>l:Ex<Cr>", "Open netrw in new right split")

-- switch to split
map("n", "<leader>h", "<C-w>h", "Focus split left")
map("n", "<leader>l", "<C-w>l", "Focus split right")
map("n", "<leader>j", "<C-w>j", "Focus split below")
map("n", "<leader>k", "<C-w>k", "Focus split above")

map("n", "<C-l>", ":vertical resize +3<Cr>", "Expand the current split")
map("n", "<C-h>", ":vertical resize -3<Cr>", "Shrink the current split")

---------------------------- BUFFERS ----------------------------------------
map("n", "<Tab>n", ":bnext <Cr>", "Next buffer")
map("n", "<Tab>p", ":bprevious <Cr>", "Previous buffer")
map("n", "<Tab>d", ":bd <Cr>", "Delete the current buffer")

---------------------------- QUICKFIX / MAKE --------------------------------
map("n", "<C-m>", ":make<CR><CR>:copen<CR>", "make and open quickfix")
map("n", "<C-x>", ":cclose<Cr>", "Close quickfix")
map("n", "<C-n>", ":cnext<CR>", "Next quickfix item")
map("n", "<C-p>", ":cprev<CR>", "Previous quickfix item")

---------------------------- TAGS / SOURCE-HEADER ---------------------------
-- (the jump keys themselves are OS-specific: see platform/*.lua)
-- create tags by pressing Alt+t
map("n", "<A-t>", tags.make_tags, "Create tags for ./src")

-- Toggle between source/header for C/C++/Objective-C/Objective-C++
map("n", "<C-c>", source_header.toggle, "Toggle source/header")
-- Open corresponding source/header file in the other split
map("n", "<C-S-c>", source_header.open_in_other_split, "Source/header in other split")

---------------------------- TERMINAL ---------------------------------------
map("t", "<esc><esc>", "<c-\\><c-n>", "Terminal: back to normal mode")
map({ "n", "t" }, "<C-t>", terminal.toggle, "Toggle floating terminal")

---------------------------- CONFIG -----------------------------------------
map("n", "<leader>r", function() require("config").reload() end, "Reload Neovim config")

---------------------------- NEOVIDE ----------------------------------------
if vim.g.neovide then
    local neovide = require("config.ui.neovide")
    map("n", "<C-+>", function() neovide.scale(0.1) end, "Neovide: zoom in")
    map("n", "<C-->", function() neovide.scale(-0.1) end, "Neovide: zoom out")
    map("n", "<C-0>", neovide.reset_scale, "Neovide: reset zoom")
    map("n", "<F11>", neovide.toggle_fullscreen, "Neovide: toggle fullscreen")
end
