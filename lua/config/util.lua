-- lua/config/util.lua -- small helpers shared by several modules.
local M = {}

function M.warn(msg)
    vim.notify(msg, vim.log.levels.WARN)
end

function M.exists(path)
    return vim.uv.fs_stat(path) ~= nil
end

-- First non-floating window of the current tab that is not the current window.
function M.other_window()
    local current = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= current and vim.api.nvim_win_get_config(win).relative == "" then
            return win
        end
    end
    return nil
end

-- Run fn once startup is finished (immediately-ish when called after startup, e.g. on reload).
function M.after_startup(fn)
    if vim.v.vim_did_enter == 1 then
        vim.schedule(fn)
    else
        vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = fn })
    end
end

return M
