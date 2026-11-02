-- lua/config/plugins/treesitter.lua
--
-- nvim-treesitter `main` branch (the incompatible rewrite; needs Neovim 0.12+):
--   * there is no `nvim-treesitter.configs`, no `ensure_installed`, no `highlight = {...}`
--   * parsers AND queries are installed into `install_dir`; setup() prepends it to 'runtimepath'
--   * highlighting is Neovim's own: vim.treesitter.start() from a FileType autocmd
--   * installing needs: tar, curl, a C compiler and `tree-sitter-cli` >= 0.26.1 (package
--     manager, NOT npm). After updating the plugin by hand, run :TSUpdate.
--
-- Parsers are built per machine, so the folder is git-ignored:
--     echo '/treesitter_parsers/' >> ~/.config/nvim/.gitignore
local util = require("config.util")

local parser_dir = vim.fn.stdpath("config") .. "/treesitter_parsers"

-- Parser names. They must equal the filetype name (true for all of these); for a language
-- where they differ, add vim.treesitter.language.register(<parser>, <filetype>).
local languages = { "c", "cpp", "lua", "python", "go", "html", "hlsl", "templ", "dart" }

-- 1. Highlighting -----------------------------------------------------------------------
-- Only start when a parser exists (installed ones, or the c/lua parsers bundled with Neovim).
-- Real errors (e.g. query problems) are deliberately NOT swallowed so they show up.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ConfigTreesitter", { clear = true }),
    pattern = languages,
    callback = function(args)
        if #vim.api.nvim_get_runtime_file("parser/" .. args.match .. ".*", false) == 0 then
            return
        end
        vim.treesitter.start(args.buf)
    end,
})

-- 2. Setup + install --------------------------------------------------------------------
local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
    util.warn("nvim-treesitter not found (expected in pack/*/start); treesitter install skipped")
    return
end

vim.fn.mkdir(parser_dir, "p")
ts.setup({ install_dir = parser_dir })

local function missing_parsers()
    local missing = {}
    for _, lang in ipairs(languages) do
        if vim.fn.glob(parser_dir .. "/parser/" .. lang .. ".*") == "" then
            missing[#missing + 1] = lang
        end
    end
    return missing
end

local missing = missing_parsers()
if #missing > 0 then
    -- install() is asynchronous; wait until startup is done so the whole runtime is in place.
    util.after_startup(function()
        if vim.fn.executable("tree-sitter") ~= 1 then
            util.warn(
                "nvim-treesitter: `tree-sitter` CLI not found, cannot install: "
                    .. table.concat(missing, ", ")
            )
            return
        end
        vim.notify("nvim-treesitter: installing " .. table.concat(missing, ", "))
        ts.install(missing)
    end)
end
