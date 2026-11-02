-- lua/config/ui/neovide.lua -- Neovide-only settings. Its keymaps (<F11>, <C-+> ...) are in keymaps.lua.
local M = {}

if not vim.g.neovide then
    return M
end

vim.g.neovide_progress_bar_enabled = false
vim.g.neovide_hide_mouse_when_typing = true

-- vim.o.guifont is set per OS in platform/*.lua

--vim.g.neovide_position_animation_length = 0
--vim.g.neovide_cursor_animation_length = 0.00
--vim.g.neovide_cursor_trail_size = 0
--vim.g.neovide_cursor_animate_in_insert_mode = false
--vim.g.neovide_cursor_animate_command_line = false
--vim.g.neovide_scroll_animation_far_lines = 0
--vim.g.neovide_scroll_animation_length = 0.00

------------------------- DYNAMIC FONT RESIZING ---------------------------------------
function M.scale(amount)
    vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) + amount
end

function M.reset_scale()
    vim.g.neovide_scale_factor = 1
end

function M.toggle_fullscreen()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

return M
