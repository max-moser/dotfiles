" vim configuration by max moser, 2019-2023
"
" note: to show a variable (e.g. `path`), use
" `:set path?`


" enable synatx highlighting if available
syntax on

" tell vim we're using a dark background
set background=dark

" when opening a file, jump to the position we were at the last time
augroup BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
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

" source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

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
set undofile

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

" -------------------------------------------- "
"                  mappings                    "
" -------------------------------------------- "
" note: leader is set to '\' per default

" if clipboard is available, copy with ctrl-c
if has("clipboard")
    vnoremap <C-c> "*y :let @+=@*<CR>
endif

" save the file with ctrl-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<Cr>

" remove highlighting of search results
nnoremap <silent> <leader><Esc> :nohlsearch<CR>

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

" -------------------------------------------- "
"                 /mappings                    "
" -------------------------------------------- "

" nice color schemes:
" * afterglow
" * deus
" * gruvbox
colorscheme afterglow
