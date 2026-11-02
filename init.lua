-- init.lua -- entry point. Keep this tiny; everything lives in lua/config/.
-- Plugins are loaded from pack/plugins/start/ (managed by hand, never touched by this config).

-- Leaders must be set before any mapping is defined.
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

require("config").setup()
