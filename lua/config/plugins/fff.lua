-- lua/config/plugins/fff.lua -- fff.nvim (file finder / live grep). Its keymaps are in keymaps.lua.
local ok, fff = pcall(require, "fff")
if not ok then
    require("config.util").warn("fff.nvim not found; <leader>ff / fg / fw will not work")
    return
end

fff.setup({
    select = {
        select_window = function(_current_buf, _action)
            return nil
        end,
    },
})
