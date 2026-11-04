local function align_lines(opts)
    local delimiter = opts.args

    if delimiter == "" then
        vim.notify("Usage: :Align <string>", vim.log.levels.ERROR)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(
        0,
        opts.line1 - 1,
        opts.line2,
        false
    )

    local matches = {}
    local max_width = 0

    -- Find the first occurrence of the delimiter on each line.
    for i, line in ipairs(lines) do
        local pos = line:find(delimiter, 1, true)

        if pos then
            local prefix = line:sub(1, pos - 1)
            local width = vim.fn.strdisplaywidth(prefix)

            matches[i] = {
                pos = pos,
                width = width,
            }

            max_width = math.max(max_width, width)
        end
    end

    -- Insert spaces to align the delimiters.
    for i, match in pairs(matches) do
        local line = lines[i]
        local padding = string.rep(" ", max_width - match.width)

        lines[i] =
            line:sub(1, match.pos - 1) ..
            padding ..
            line:sub(match.pos)
    end

    vim.api.nvim_buf_set_lines(
        0,
        opts.line1 - 1,
        opts.line2,
        false,
        lines
    )
end

vim.api.nvim_create_user_command("Align", align_lines, {
    nargs = 1,
    range = true,
    desc = "Align lines by a string",
})
