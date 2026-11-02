-- lua/config/ui/colors.lua -- colorscheme + custom TODO / NOTE / IMPORTANT highlighting.
local util = require("config.util")

---------------------------- COLORSCHEME ----------------------------------------
-- alternatives: gruvbox, kanagawa-dragon, nightfox
vim.o.background = "dark"
if not pcall(vim.cmd.colorscheme, "gruvbox-material") then
    util.warn("colorscheme gruvbox-material not found")
end

------------------------ TODO / NOTE / IMPORTANT --------------------------------
-- this does not work with my current colorscheme (probably can make it work, by colorscheme config but I won't)
-- Todo is redefined here, after the colorscheme, so it always wins.
local highlights = {
    Todo = { fg = "#ff2222", bold = true, underline = true },
    Note = { fg = "#22cc22", bold = true, underline = true },
    Important = { fg = "#cccc22", bold = true, underline = true },
}

local keywords = { Todo = "TODO", Note = "NOTE", Important = "IMPORTANT" }

local function apply_highlights()
    for group, def in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, def)
    end
end

-- matchadd() is window-local, so every normal window needs its own matches (new tabs and
-- splits start without them). Checking getmatches() keeps this idempotent.
local function add_matches()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
        return -- skip floating windows (terminal, fff picker, ...)
    end
    local present = {}
    for _, m in ipairs(vim.fn.getmatches()) do
        present[m.group .. ":" .. (m.pattern or "")] = true
    end
    for group, word in pairs(keywords) do
        if not present[group .. ":" .. word] then
            vim.fn.matchadd(group, word)
        end
    end
end

local group = vim.api.nvim_create_augroup("ConfigKeywordHighlights", { clear = true })
-- a :colorscheme wipes custom groups, so re-apply
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = apply_highlights })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "TabNewEntered" }, { group = group, callback = add_matches })

apply_highlights()
add_matches()
