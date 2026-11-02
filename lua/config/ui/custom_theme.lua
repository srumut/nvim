-- lua/config/ui/custom_theme.lua -- your old hand-made colorscheme, previously a commented-out block.
-- NOT loaded by default. To try it:  :lua require("config.ui.custom_theme").apply()
local M = {}

local colors = {
    background = "#191919",
    default = "#dcdddc",
    comment = "#9e9e9e",
    string = "#8fb76c",
    statement = "#e5d34b",
    type = "#808585",
    cursor = "#fddd34",
    error_msg = "#ff3e47",
    warning_msg = "#a98049",
    preproc = "#808585",
    visual = "#393939",
    constant = "#cdad14",
}

function M.apply()
    local set_color = vim.api.nvim_set_hl

    vim.opt.guicursor = "n-v-c:block-Cursor,i-ci:ver25-Cursor" -- so that cursor color works properly

    set_color(0, "Normal", { bg = colors.background, fg = colors.default })
    set_color(0, "Visual", { bg = colors.visual })
    set_color(0, "Comment", { fg = colors.comment })
    set_color(0, "String", { fg = colors.string })
    set_color(0, "Identifier", { fg = colors.default }) -- any variable name
    set_color(0, "Function", { fg = colors.default })
    set_color(0, "Constant", { fg = colors.constant })
    set_color(0, "Statement", { fg = colors.statement })
    set_color(0, "CurSearch", { fg = "#bbddbb" }) -- Current match for the search pattern
    set_color(0, "IncSearch", { fg = "#bbddbb" })
    set_color(0, "Substitute", { fg = "#bbddbb" })
    set_color(0, "Cursor", { bg = colors.cursor, fg = colors.background })
    set_color(0, "ErrorMsg", { fg = colors.error_msg })
    set_color(0, "WarningMsg", { fg = colors.warning_msg })
    set_color(0, "PreProc", { fg = colors.preproc }) -- Preprocessor
    set_color(0, "Type", { fg = colors.type })
    set_color(0, "StorageClass", { fg = colors.type })
    set_color(0, "Structure", { fg = colors.type })
    set_color(0, "Typedef", { fg = colors.type })
    set_color(0, "Special", { fg = colors.default })
    set_color(0, "QuickFixLine", { fg = colors.error_msg })
end

return M
