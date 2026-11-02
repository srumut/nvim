-- lua/config/autocmds.lua -- every autocmd, each in a named group with clear = true, so that
-- reloading the config (<leader>r) never stacks duplicates.

---------------------------- ROOT DIRECTORY ---------------------------------
-- if the path passed to neovim is a directory make that directory neovims root (run neovim
-- inside that directory, if given is a file than make root that file's parent directory
--
-- ORDER MATTERS: this must be registered before the auto-vsplit below, so the new split
-- inherits the window-local directory.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ConfigRootDir", { clear = true }),
    callback = function()
        local arg = vim.fn.argv(0)
        if arg == "" then
            return
        end

        -- make absolute path
        local full = vim.fn.fnamemodify(arg, ":p")
        local stat = vim.uv.fs_stat(full)

        -- existing directory -> that directory; file OR non-existing file -> its parent
        local root = (stat and stat.type == "directory") and full or vim.fn.fnamemodify(full, ":h")
        vim.cmd.lcd(vim.fn.fnameescape(root))
    end,
})

---------------------------- WINDOW LAYOUT ----------------------------------
-- Automatically create 2 vertical splits at startup and in new tabs
local function ensure_two_splits()
    -- only create splits if there's only one window
    if #vim.api.nvim_tabpage_list_wins(0) == 1 then
        vim.cmd("vsplit")
    end
end

vim.api.nvim_create_autocmd({ "TabNewEntered", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("EnsureTwoVerticalSplits", { clear = true }),
    callback = ensure_two_splits,
})

-- this auto commands ensure splits are evenly distributed when window resizes
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("ConfigEqualizeSplits", { clear = true }),
    callback = function()
        vim.cmd("wincmd =")
    end,
})

---------------------------- QUICKFIX ---------------------------------------
-- wrap the text inside of quickfix list
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ConfigQuickfixWrap", { clear = true }),
    pattern = "qf",
    callback = function()
        vim.opt_local.wrap = true
    end,
})

---------------------------- C/C++ HEADER GUARDS ----------------------------
vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("CppHeaderGuards", { clear = true }),
    pattern = { "*.h", "*.hpp" },
    callback = function()
        local name = vim.fn.expand("%:t:r"):upper()
        local guard = (name:gsub("%W", "_")) .. "_" .. vim.fn.expand("%:e"):upper()

        vim.api.nvim_buf_set_lines(0, 0, 0, false, {
            "#if !defined(" .. guard .. ")",
            "",
            "",
            "",
            "",
            "",
            "#define " .. guard,
            "#endif",
        })
        vim.cmd("normal! 4G")
    end,
})
