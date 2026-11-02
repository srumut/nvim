-- lua/config/platform/macos.lua -- everything that only applies on macOS. Loaded last,
-- from config/init.lua.
vim.o.guifont = "Liberation Mono:h13"

-- tag jumping remaps (Cmd key)
local tags = require("config.features.tags")

vim.keymap.set("n", "<D-g>", "<C-]>", { silent = true, desc = "Tags: jump to tag" })
vim.keymap.set("n", "<D-w>", tags.in_other_window, { silent = true, desc = "Tags: definition in other split" })
vim.keymap.set("n", "<D-b>", "<C-t>", { silent = true, desc = "Tags: jump back" })
