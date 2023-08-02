-- ------------ --
-- key mappings --
-- ------------ --

local function map(mode, key_combo, command, opts)
    vim.keymap.set(mode, key_combo, command, opts)
end

-- if the clipboard is available make `ctrl-c` work
if vim.fn.has("clipboard") then
    map("v", "<C-c>", '"*y :let @+=@*<CR>', { silent = true })
end

-- save the file with `ctrl-s`
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

-- open up the file explorer (netrw)
map("n", "<Leader>fe", ":Explore<CR>", { silent = true })

-- emacs/shell-like hotkeys for moving around text in insert & cmdline mode
map("i", "<C-a>", "<Esc>0i")
map("c", "<C-a>", "<C-b>")
map("i", "<C-e>", "<Esc>A")
map({"i", "c"}, "<C-b>", "<Left>")
map({"i", "c"}, "<C-f>", "<Right>")
map({"i", "c"}, "<M-b>", "<S-Left>")
map({"i", "c"}, "<M-f>", "<S-Right>")
map({"i", "c"}, "<M-BS>", "<C-w>")


-- ----------------------- --
-- tab & buffer management --
-- ----------------------- --
map("n", "<Leader>T", ":tabnew<CR>", { silent = true })
map("n", "<Leader>tn", ":tabnew<CR>", { silent = true })
map("n", "<Leader>tq", ":tabclose<CR>", { silent = true })
map("n", "<Leader>tc", ":tabclose<CR>", { silent = true })
map("n", "<Leader>q", ":bdelete<CR>", { silent = true })
map("n", "<Leader>Q", ":quit<CR>", { silent = true })

-- `ctrl-shift-{h,l}` for switching to the next/previous tab
map("n", "<C-h>", "gT")
map("n", "<C-l>", "gt")

-- `ctrl-shift-{h,l}` for switching to the next/previous buffer
map("n", "<C-S-h>", ":bprevious<CR>", { silent = true })
map("n", "<C-S-l>", ":bnext<CR>", { silent = true })


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
