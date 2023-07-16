-- -------- --
-- settings --
-- -------- --

local opt = vim.opt

-- tell vim we're usually using a dark background
opt.background = "dark"

-- relative line numbering
opt.number = true
opt.relativenumber = true

-- show (partial) command in status line
opt.showcmd = true

-- show matching brackets
opt.showmatch = true

-- smart-case matching
opt.ignorecase = true
opt.smartcase = true

-- incremental search
opt.incsearch = true

-- automatically save before commands like :next and :make
opt.autowrite = true

-- hide buffers when they are abandoned
opt.hidden = true

-- enable mouse usage (all modes)
opt.mouse = "a"

-- enable smart indenting (reacts to the language's syntax)
opt.smartindent = true

-- show trailing whitespaces with '-' and tabs with '>'
opt.list = true
opt.listchars = { tab = "> ", trail = "-", nbsp = "+" }

-- highlight current line
opt.cursorline = true

-- set display and handling of tab stops
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 0

-- keep a padding of characters/lines at the sides, to provide context
opt.scrolloff = 5
opt.sidescrolloff = 5

-- white 'ruler' line at the bottom of the screen
opt.ruler = true

-- keep an undo-file for edited files s.t. operations can be undone after opening the file
opt.undofile = true

-- get rid of the nasty sounds
opt.errorbells = false
opt.visualbell = false

-- monitor opened files for changes
opt.autoread = true

-- enable the tab completion in commands
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- make the cmd line one line high
opt.cmdheight = 1

-- make it so <C-w> won't stop at the last start of insert
opt.backspace = { "indent", "eol", "nostop" }

-- sync system clipboard
opt.clipboard = "unnamedplus"

-- options for the completion menu
opt.completeopt = {"menu", "menuone", "noselect", "preview"}

-- ask the user for confirmation on some actions instead of just denying them
opt.confirm = true

-- enable true color support
opt.termguicolors = true
