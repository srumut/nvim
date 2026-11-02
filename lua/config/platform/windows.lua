-- lua/config/platform/windows.lua -- everything that only applies on Windows. Loaded last,
-- from config/init.lua.
vim.o.guifont = "Liberation Mono:h10"

vim.opt.tags = table.concat({
    "tags",
    vim.fn.expand("~/tags/windows.tags"),
    vim.fn.expand("~/tags/windows_preprocessed.tags"),
}, ",")

require("config.platform.ctrl_keys")
