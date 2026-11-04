-- Convention: requiring a module is safe and idempotent. Modules either run their setup on
-- require (options, keymaps, autocmds, ui/*, plugins/*, platform/*) or return a table of
-- functions (features/*, util).
local M = {}

require("config.features.align")

-- A failing module must not take the rest of the config down, but it must also not fail
-- silently (that is how the old treesitter setup hid its problem).
local function load(name)
    local ok, err = pcall(require, "config." .. name)
    if not ok then
        vim.schedule(function()
            vim.notify(("config.%s failed to load:\n%s"):format(name, err), vim.log.levels.ERROR)
        end)
    end
end

-- vim.uv.os_uname().sysname -> platform file. Anything unknown is treated like Linux.
local platform_files = { Linux = "linux", Darwin = "macos", Windows_NT = "windows" }

function M.setup()
    load("options")
    load("filetypes")

    load("plugins.treesitter")
    load("plugins.fff")
    load("plugins.vim_go")

    load("ui.colors")
    load("ui.neovide")

    load("features.tags")      -- registers :Maketags
    load("features.terminal")  -- registers :Fterminal

    load("keymaps")
    load("autocmds")

    local sysname = vim.uv.os_uname().sysname
    load("platform." .. (platform_files[sysname] or "linux"))
end

-- Same key as before (<leader>r), but modules are dropped from package.loaded first,
-- otherwise re-sourcing init.lua would just get the cached modules back.
function M.reload()
    for name in pairs(package.loaded) do
        if name == "config" or vim.startswith(name, "config.") then
            package.loaded[name] = nil
        end
    end
    local init = vim.env.MYVIMRC or (vim.fn.stdpath("config") .. "/init.lua")
    vim.cmd.source(vim.fn.fnameescape(init))
    vim.notify("Config reloaded")
end

return M
