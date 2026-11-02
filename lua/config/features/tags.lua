-- lua/config/features/tags.lua -- ctags helpers: jump to definition, jump in the other split,
-- list all matches in quickfix, and (re)generate the tags file. Keys are in keymaps.lua
-- (shared: <A-t>) and platform/*.lua (OS-specific jump keys).
--
-- NOW
-- use CTRL+] to jump to tag under cursor
-- use G+CTRL+] for ambigious tags
-- use ^to jump back up in the tags stack

-- BUT
-- this does not help if you want a visual list of tags
local util = require("config.util")

local M = {}

-- Create the "tags" files (you may need to install ctags first)
vim.api.nvim_create_user_command("Maketags", "!ctags -R .", {})

---------------------------- helpers -----------------------------------------

local function find_tags(word)
    -- taglist() takes a Vim regex, so escape Vim-regex specials (not Lua pattern specials)
    return vim.fn.taglist("^" .. vim.fn.escape(word, "\\.*$^~[") .. "$")
end

-- Returns the tags for the word under the cursor, or nil (after telling the user why).
local function tags_under_cursor()
    local word = vim.fn.expand("<cword>")
    if word == "" then
        util.warn("No tag under cursor")
        return nil, word
    end
    local tags = find_tags(word)
    if vim.tbl_isempty(tags) then
        util.warn("No tags found")
        return nil, word
    end
    return tags, word
end

-- Prefer implementations over prototypes (kind "p").
local function pick_best(tags)
    for _, tag in ipairs(tags) do
        if tag.kind ~= "p" then
            return tag
        end
    end
    return tags[1]
end

-- Tags carry either a line number (ctags --fields=+n) or an ex search command like
-- /^int main(void)$/;"  -- handle both, so tags files without `line:` still land correctly.
local function tag_line(tag)
    return tonumber(tag.line) or tonumber(tag.cmd)
end

local function search_pattern(tag)
    return ((tag.cmd or ""):gsub("^/", ""):gsub('/;"$', ""):gsub("\\/", "/"))
end

local function place_cursor(tag)
    local line = tag_line(tag)
    if line then
        vim.fn.cursor(line, 1)
        return
    end
    local pat = search_pattern(tag)
    if pat ~= "" then
        vim.fn.search(pat, "cw")
    end
end

local function open_tag(tag)
    vim.cmd.edit(vim.fn.fnameescape(tag.filename))
    place_cursor(tag)
end

-- Record the jump on the tag stack, so <C-t> (what <C-b>/<D-b> run) can pop back. A plain
-- :edit + cursor() never touches the stack, which is why going back used to not work.
local function push_tagstack(name)
    local pos = vim.fn.getpos(".")
    local from = { vim.api.nvim_get_current_buf(), pos[2], pos[3], pos[4] }
    vim.fn.settagstack(
        vim.api.nvim_get_current_win(),
        { items = { { tagname = name, from = from } } },
        "t"
    )
end

---------------------------- public API --------------------------------------

-- single tag jump, favors implementations over prototypes
function M.goto_definition()
    local tags, word = tags_under_cursor()
    if not tags then
        return
    end
    push_tagstack(word)
    vim.cmd("normal! m'") -- also set the jumplist mark, so <C-o> works too
    open_tag(pick_best(tags))
end

-- open the definition of the tag in the other window
function M.in_other_window()
    local tags = tags_under_cursor()
    if not tags then
        return
    end
    local target = util.other_window()
    if not target then
        util.warn("Need two splits")
        return
    end
    local best = pick_best(tags)
    vim.api.nvim_win_call(target, function()
        open_tag(best)
    end)
    vim.api.nvim_set_current_win(target)
end

-- list every match in the quickfix window
function M.to_quickfix()
    local tags, word = tags_under_cursor()
    if not tags then
        return
    end

    table.sort(tags, function(a, b)
        -- prototypes first, then by filename
        local a_proto, b_proto = a.kind == "p", b.kind == "p"
        if a_proto ~= b_proto then
            return a_proto
        end
        return a.filename < b.filename
    end)

    local items = {}
    for _, tag in ipairs(tags) do
        local item = {
            filename = tag.filename,
            text = string.format(
                "[%s] %s (%s)",
                tag.kind or "?",
                tag.name,
                vim.fn.fnamemodify(tag.filename, ":.")
            ),
        }
        local line = tag_line(tag)
        if line then
            item.lnum = line
            item.col = 1
        else
            item.lnum = 0
            item.pattern = search_pattern(tag)
        end
        items[#items + 1] = item
    end

    vim.fn.setqflist({}, "r", { title = "Tags: " .. word, items = items })
    vim.cmd("copen")
    -- Put the cursor on the first result.
    vim.cmd("cc")
end

-- generate tags for ./src
function M.make_tags()
    if not util.exists("./src") then
        print("Error: src folder doesn't exist")
        return
    end
    vim.fn.system("ctags -R --fields=+n --c++-kinds=+p --c-kinds=+p src")
    if vim.v.shell_error == 0 then
        print("Tags created successfully")
    else
        print("Error: tags couldn't be created (shell might not be accessible, or some other reason)")
    end
end

return M
