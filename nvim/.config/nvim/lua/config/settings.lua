-- -------- --
-- settings --
-- -------- --

local opt = vim.opt
local fn = vim.fn

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

-- enable mouse usage (all modes)
opt.mouse = "a"

-- enable smart indenting (reacts to the language's syntax)
opt.smartindent = true

-- wrap lines, and have wrapped lines indented as well
opt.wrap = true
opt.breakindent = true

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
opt.completeopt = { "menu", "menuone", "noselect", "preview" }

-- ask the user for confirmation on some actions instead of just denying them
opt.confirm = true

-- abandon buffers when they're unloaded (e.g. closed), after confirmation
opt.hidden = false

-- enable true color support
opt.termguicolors = true

-- timeout for command sequences to complete
opt.timeoutlen = 750

-- the key for opening the command-line window (history) in cmdline mode
opt.cedit = "<C-h>"

-- simple tab names without the file paths in it
function SimpleTabline()
    local tabline = ""
    local tab_names = {}
    local min_tab_name_len = 16

    for tab = 1, fn.tabpagenr("$"), 1 do
        -- for the label of the tab, we use the name of the buffer in the focused window
        -- if it's a file name, we omit all parts of its path
        local buf_list = fn.tabpagebuflist(tab)
        local win_num = fn.tabpagewinnr(tab)
        local buf_name = fn.bufname(buf_list[win_num])
        local tab_name = fn.fnamemodify(buf_name, ":t")
        if tab_name == "" then
            tab_name = "[No Name]"
        end
        min_tab_name_len = math.max(min_tab_name_len, #tab_name)
        tab_names[tab] = tab_name
    end

    for tab, tab_name in ipairs(tab_names) do
        local label
        if fn.tabpagenr() == tab then
            label = "%#TabLineSel# "
        else
            label = "%#TabLine# "
        end

        -- number the tab page (for mouse clicks)
        label = string.format("%s%%%sT", label, tab)

        -- pad all labels to the same length
        local padding = string.rep(" ", (min_tab_name_len - #tab_name + 1))
        label = string.format("%s%s%s", label, tab_name, padding)
        tabline = tabline .. label
    end

    return tabline .. "%#TabLineFill#%T"
end

opt.tabline = "%!v:lua.SimpleTabline()"

-- setting up folds
-- (treesitter will only be used if the file is small enough, cf. `treesitter.lua`)
opt.foldmethod = "expr"
opt.foldexpr = "0"
opt.foldenable = false

-- configuration for neovide
if vim.g.neovide then
    opt.title = true
end
