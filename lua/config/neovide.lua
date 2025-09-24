if vim.g.neovide then
    vim.o.guifont = "Liberation Mono:h10"

    vim.keymap.set("n", "<F11>", function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end)
end
