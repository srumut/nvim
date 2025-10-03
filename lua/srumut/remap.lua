-- vim.keymap.set([mode], [key_combination], [command])

-- in normal mode leader + p + v key combination runs the command Ex
-- basically opens up the Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- when Ctrl+d or Ctrl+u is pressed also run zz (center the cursor)
vim.keymap.set("n", "<C-j>", "<C-d>zz")
vim.keymap.set("n", "<C-k>", "<C-u>zz")

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
