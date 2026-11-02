-- lua/config/platform/linux.lua -- everything that only applies on Linux (also the fallback
-- for unknown Unix-likes). Loaded last, from config/init.lua.
vim.o.guifont = "Liberation Mono:h10"

-- Use system clipboard by default
vim.opt.clipboard = "unnamedplus"

require("config.platform.ctrl_keys")
