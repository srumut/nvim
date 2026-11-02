-- lua/config/platform/ctrl_keys.lua -- tag-jump keys shared by Linux and Windows
-- (macOS uses <D-...> instead, see macos.lua). Required from linux.lua and windows.lua.
local tags = require("config.features.tags")

local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<C-g>", tags.goto_definition, "Tags: go to definition")
map("<C-S-g>", tags.in_other_window, "Tags: definition in other split")
map("<C-b>", "<C-t>", "Tags: jump back")
map("<C-a>", tags.to_quickfix, "Tags: all matches in quickfix")
