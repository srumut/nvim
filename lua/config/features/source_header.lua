-- lua/config/features/source_header.lua -- toggle between source/header for C / C++ /
-- Objective-C / Objective-C++. Keys (<C-c>, <C-S-c>) are in keymaps.lua.
local util = require("config.util")

local M = {}

-- extension (without the dot) -> alternate extensions, in order of preference
local alternate_exts = {
    c = { "h" },
    m = { "h" },
    cpp = { "h", "hpp" },
    cc = { "h", "hpp" },
    mm = { "h", "hpp" },
    h = { "cpp", "cc", "c", "m", "mm" },
    hpp = { "cpp", "cc", "mm" },
}

-- candidate files for the current buffer, or nil (after telling the user why)
local function alternates()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        print("Buffer has no file name")
        return nil
    end
    local exts = alternate_exts[vim.fn.fnamemodify(path, ":e")]
    if not exts then
        print("Not a recognized source/header file")
        return nil
    end
    local base = vim.fn.fnamemodify(path, ":r")
    local targets = {}
    for _, ext in ipairs(exts) do
        targets[#targets + 1] = base .. "." .. ext
    end
    return targets
end

local function first_readable(targets)
    for _, f in ipairs(targets) do
        if vim.fn.filereadable(f) == 1 then
            return f
        end
    end
    return nil
end

-- Toggle between source/header in the current window
function M.toggle()
    local targets = alternates()
    if not targets then
        return
    end
    local f = first_readable(targets)
    if not f then
        print("No matching file found")
        return
    end
    vim.cmd.edit(vim.fn.fnameescape(f))
end

-- Open corresponding source/header file in the other split
function M.open_in_other_split()
    local targets = alternates()
    if not targets then
        return
    end
    local f = first_readable(targets)
    if not f then
        print("No matching file found")
        return
    end
    local target_win = util.other_window()
    if not target_win then
        print("Need at least two splits")
        return
    end
    local bufnr = vim.fn.bufadd(f)
    vim.fn.bufload(bufnr)
    vim.api.nvim_win_set_buf(target_win, bufnr)
    vim.api.nvim_set_current_win(target_win)
end

return M
