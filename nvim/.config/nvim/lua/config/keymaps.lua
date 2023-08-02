-- ------------ --
-- key mappings --
-- ------------ --

local function map(mode, key_combo, command, opts)
    vim.keymap.set(mode, key_combo, command, opts)
end

-- if the clipboard is available make `ctrl-c` work
if vim.fn.has("clipboard") then
    map("v", "<C-c>", '"*y <Cmd>let @+=@*<CR>')
end

-- save the file with `ctrl-s`
map({"i", "n"}, "<C-s>", "<Cmd>w<CR>")

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
map("n", "<Leader><Esc>", "<Cmd>nohlsearch<CR>")

-- open up the file explorer (netrw)
map("n", "<Leader>fe", "<Cmd>Explore<CR>")

-- emacs/shell-like hotkeys for moving around text in insert & cmdline mode
map("i", "<C-a>", "<Esc>0i")
map("c", "<C-a>", "<C-b>")
map("i", "<C-e>", "<Esc>A")
map({"i", "c"}, "<C-b>", "<Left>")
map({"i", "c"}, "<C-f>", "<Right>")
map({"i", "c"}, "<M-b>", "<S-Left>")
map({"i", "c"}, "<M-f>", "<S-Right>")
map({"i", "c"}, "<M-BS>", "<C-w>")

-- disable the hotkeys to hell
-- (the command/search history can always be brought up with the 'cedit' key in cmdline mode)
map("", "q:", "<Nop>")
map("", "q/", "<Nop>")
map("", "q?", "<Nop>")


-- ----------------------- --
-- tab & buffer management --
-- ----------------------- --
map("n", "<Leader>T", "<Cmd>tabnew<CR>")
map("n", "<Leader>tn", "<Cmd>tabnew<CR>")
map("n", "<Leader>tq", "<Cmd>tabclose<CR>")
map("n", "<Leader>tc", "<Cmd>tabclose<CR>")
map("n", "<Leader>q", "<Cmd>bdelete<CR>")
map("n", "<Leader>Q", "<Cmd>quit<CR>")

-- `ctrl-shift-{h,l}` for switching to the next/previous tab
map("n", "<C-h>", "gT")
map("n", "<C-l>", "gt")

-- `ctrl-shift-{h,l}` for switching to the next/previous buffer
map("n", "<C-S-h>", "<Cmd>bprevious<CR>")
map("n", "<C-S-l>", "<Cmd>bnext<CR>")


-- --------------------- --
-- telescope keybindings --
-- --------------------- --
local builtin = require("telescope.builtin")

-- `ctrl-p` for fuzzy-finding files in the current directory
map("n", "<C-p>", builtin.find_files, {})

-- `ctrl-tab` for fuzzy-finding buffers
map({ "i", "n" }, "<C-Tab>", builtin.buffers, {})

-- further keymappings
map("n", "<Leader>fg", builtin.live_grep, {})
map("n", "<Leader>fh", builtin.help_tags, {})
