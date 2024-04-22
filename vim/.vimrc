" vim configuration by max moser, 2019-2023


" -------------------------------------------- "
"                   settings                   "
" -------------------------------------------- "

" set the leader key to space (default is backslash)
let mapleader = " "

" enable synatx highlighting if available
syntax on

" tell vim we're using a dark background
set background=dark

" have vim load indentation rules and plugins according to the detected filetype
filetype plugin indent on

" show the (partial) command in the status line
set showcmd

" show matching brackets
set showmatch

" smart-case for search
set ignorecase
set smartcase

" when searching, highlight current matches while writing
set hlsearch
set incsearch

" automatically save before commands like :next and :make
set autowrite

" hide buffers when they are abandoned
set hidden

" enable mouse usage (all modes)
set mouse=a

" enable smart indenting (reacts to the language's syntax)
set smartindent

" show trailing whitespaces with '-' and tabs with '>'
set list
set listchars=tab:>~,trail:-,nbsp:+

" line numbering
set number
set relativenumber

" highlight current line
set cursorline

" set display and handling of tab stops
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=0

" keep a padding of characters/lines at the sides, to provide context
set scrolloff=5
set sidescrolloff=5

" white 'ruler' line at the bottom of the screen
set ruler

" keep an undo-file for edited files s.t. operations can be undone after opening the file
" the trailing double slash in undodir causes special handling of file names
set undofile
set undodir=~/.cache/vim/undo//

" get rid of the nasty sounds
set noerrorbells
set novisualbell

" monitor opened files for changes
set autoread

" enable the tab completion in commands
set wildmenu
set wildmode=longest:full,full

" make the cmd line one line high
set cmdheight=1

" make it so <C-w> won't stop at the last start of insert
set backspace=indent,eol,nostop

" sync system clipboard
set clipboard^=unnamedplus

" ask the user for confirmation on some actions instead of just denying them
set confirm

" enable true color support
set termguicolors

" options for the completion menu
set completeopt=menu,menuone,noselect,preview

" the time to wait (in ms) for new inputs on partial keymaps
set timeoutlen=750

" the key for opening the command-line window (history) in cmdline mode
set cedit="<C-h>"

" simple custom function for labelling tabs, defined below
set tabline=%!SimpleTabLine()

" use a thin cursor in insert mode, and a block in normal mode
let &t_EI = "\e[2 q"
let &t_SI = "\e[6 q"

" nice color schemes:
" * afterglow
" * deus
" * gruvbox
colorscheme afterglow


" -------------------------------------------- "
"                 key mappings                 "
" -------------------------------------------- "

" if clipboard is available, copy with ctrl-c
if has("clipboard")
    vnoremap <C-c> "*y <Cmd>let @+=@*<CR>
endif

" save the file with ctrl-s
nnoremap <C-s> <Cmd>w<CR>
inoremap <C-s> <Cmd>w<Cr>

" remove highlighting of search results
nnoremap <leader><Esc> <Cmd>nohlsearch<cr>
" for whatever reason, this seems to be necessary with Kitty keyboard protocol
" (vim 9.0, patches 1-1676)... sometimes <Esc> also shows up as <t_ýk>
nnoremap <leader><Esc>[27u <Cmd>nohlsearch<cr>

" enable shifting selected lines around with J (down) and K (up)
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" special pasting to not override pasting content after paste
xnoremap <leader>p "_dP

" move to start/end of line with H/L
nnoremap H ^
nnoremap L $

" don't leave visual mode when indenting
xnoremap > >gv
xnoremap < <gv

" shift-tab to remove one level of indent in insert mode
inoremap <S-Tab> <C-d>

" open up the file explorer (netrw)
nnoremap <Leader>fe <Cmd>Explore<CR>

" emacs/shell-like hotkeys for moving around text in insert & cmdline mode
inoremap <C-a> <Esc>0i
cnoremap <C-a> <C-b>
inoremap <C-e> <Esc>A
inoremap <C-b> <Left>
cnoremap <C-b> <Left>
inoremap <C-f> <Right>
cnoremap <C-f> <Right>
inoremap <M-b> <S-Left>
cnoremap <M-b> <S-Left>
inoremap <M-f> <S-Right>
cnoremap <M-f> <S-Right>
inoremap <M-BS> <C-w>
cnoremap <M-BS> <C-w>

" disable the hotkeys to hell
" (the command/search history can always be brought up with the 'cedit' key in cmdline mode)
noremap q: <Nop>
noremap q/ <Nop>
noremap q? <Nop>
noremap Q <Nop>

" tab & buffer management
nnoremap <Leader>T <Cmd>tabnew<CR>
nnoremap <Leader>tn <Cmd>tabnew<CR>
nnoremap <Leader>tq <Cmd>tabclose<CR>
nnoremap <Leader>tc <Cmd>tabclose<CR>
nnoremap <Leader>q <Cmd>bdelete<CR>
nnoremap <Leader>Q <Cmd>quit<CR>

" `ctrl-shift-{h,l}` for switching to the next/previous tab
nnoremap <C-h> gT
nnoremap <C-l> gt

" `ctrl-shift-{h,l}` for switching to the next/previous buffer
nnoremap <C-S-h> <Cmd>bprevious<CR>
nnoremap <C-S-l> <Cmd>bnext<CR>


" -------------------------------------------- "
"                  functions                   "
" -------------------------------------------- "

" function used for labelling tabs
function! SimpleTabLine()
    let tabLine = ''
    let tabNames = []
    let minTabNameLen = 16
    let numTabs = tabpagenr('$')

    for tab in range(numTabs)
        " for the label of the tab, we use the name of the buffer in the focused window
        " if it's a file name, we omit all parts of its path
        let bufList = tabpagebuflist(tab + 1)
        let winNum = tabpagewinnr(tab + 1)

        let tabName = ''
        if len(bufList) >= winNum
            let bufName = bufname(bufList[winNum - 1])
            let tabName = fnamemodify(bufName, ':t')
        endif

        if tabName == ''
            let tabName = '[No Name]'
        endif

        let minTabNameLen = max([minTabNameLen, len(tabName)])
        call add(tabNames, tabName)
    endfor

    for tab in range(numTabs)
        if tabpagenr() == (tab + 1)
            let label = '%#TabLineSel# '
        else
            let label = '%#TabLine# '
        endif

        " number the tab page (for mouse clicks)
        let label ..= '%' .. (tab + 1) .. 'T'

        " pad all labels to the same length
        let tabName = tabNames[tab]
        let padding = repeat(' ', (minTabNameLen - len(tabName) + 1))
        let tabLine ..= label .. tabName .. padding
    endfor

    return tabLine .. '%#TabLineFill#%T'
endfunction

" function for mapping some netrw hotkeys in the current buffer
function! MapNetrwHotkeys()
    map <buffer> h -
    map <buffer> l <CR>
    map <buffer> Q <Cmd>bdelete<CR>
endfunction


" -------------------------------------------- "
"                 autocommands                 "
" -------------------------------------------- "

" when opening a file, jump to the position we were at the last time
augroup BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" when opening a netrw (file explorer) buffer, set some custom keymaps
autocmd FileType netrw call MapNetrwHotkeys()
