" vim configuration by max moser, 2019
"
" note: to show a variable (e.g. `path`), use
" `:set path?`

" boolean variable that enables the loading of plugins later on
let use_plugins = 0

" enable synatx highlighting if available
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd			" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden			" Hide buffers when they are abandoned
set mouse=a			" Enable mouse usage (all modes)

" enable smart indenting (reacts to the language's syntax)
set smartindent

" show trailing whitespaces with '-' and tabs with '>'
set list

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" line numbering
set number
set relativenumber

" highlight current line
hi CursorLine cterm=NONE ctermbg=235 guibg=grey40
set cursorline

" set display and handling of tab stops
set tabstop=4
set shiftwidth=0
set softtabstop=0

" keep a padding of characters/lines at the sides, to provide context
set scrolloff=5
set sidescrolloff=5

" white 'ruler' line at the bottom of the screen
set ruler

" keep an undo-file for edited files s.t. operations can be undone after
" opening the file
set undofile
set undodir=~/.local/share/nvim/undo//

" get rid of the nasty sounds
set noerrorbells
set visualbell

" monitor opened files for changes
set autoread

" enable the tab completion in commands
set wildmenu

" keep showing the status bar at the bottom
set ruler

" make the cmd line two lines high
set cmdheight=1

" set buffers to hidden when they are abandoned
set hid

" enable vim to find files in subdirectories
" (apparently may cause slowness in deep directory structures)
" set path+=**

" -------------------------------------------- "
"                  mappings                    "
" -------------------------------------------- "

" copy / paste with ^C / ^P
if has("clipboard")
	" visual non-recursive map
	vnoremap <C-c> "*y :let @+=@*<CR>

	" non-recursive map
	noremap <C-p> "+P
endif

" map ^s to save the file
noremap <C-s> :w<CR>

" leader (default: backslash) + c:
" enable / disable highlighting of current line
nnoremap <Leader>c :set cursorline!<CR>
" -------------------------------------------- "
"                 /mappings                    "
" -------------------------------------------- "

" nice color schemes:
" * afterglow
" * deus
" * gruvbox
colorscheme afterglow

" -------------------------------------------- "
"                   plugins                    "
" -------------------------------------------- "
if use_plugins == 1
	call plug#begin('~/.local/share/nvim/plugged')

	Plug 'roxma/nvim-yarp'
	Plug 'ncm2/ncm2'

	autocmd BufEnter * call ncm2#enable_for_buffer()
	set completeopt=noinsert,menuone,noselect

	Plug 'Shougo/deoplete.nvim'
	Plug 'ncm2/ncm2-bufword'
	Plug 'ncm2/ncm2-tmux'
	Plug 'ncm2/ncm2-path'

	call plug#end()
endif
" -------------------------------------------- "
"                   /plugins                   "
" -------------------------------------------- "

