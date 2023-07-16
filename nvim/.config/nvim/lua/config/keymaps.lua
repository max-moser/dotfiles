-- ------------ --
-- key mappings --
-- ------------ --

local function map(mode, key_combo, command, opts)
    vim.keymap.set(mode, key_combo, command, opts)
end

-- if the clipboard is available make ctrl-c work
if vim.fn.has("clipboard") then
    map("v", "<C-c>", '"*y :let @+=@*<CR>', { silent = true })
end

-- save the file with ctrl-s
map("n", "<C-s>", ":w<CR>")
map("i", "<C-s>", "<C-o>:w<CR>")

-- shift-tab to remove one level of indent in insert mode
map("i", "<S-Tab>", "<C-d>")

-- enable shifting selected lines around with J (down) and K (up)
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- special pasting to not override pasting content after paste
map("x", "<Leader>p", '"_dP')

-- move to start/end of line with H/L
map("n", "H", "^")
map("n", "L", "$")

-- don't leave visual mode when indenting
map("x", ">", ">gv")
map("x", "<", "<gv")

-- remove highlighting of search results
map("n", "<Leader><Esc>", ":nohlsearch<CR>", { silent = true })
