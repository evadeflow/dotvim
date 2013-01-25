" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen for clean separation of installed modules
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Turn off beeps
set vb t_vb=

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=1000

" Make tab completion for files/buffers act like bash
set wildmenu

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Don't keep a backup or swap file
set nobackup
set noswapfile

" Show the cursor position all the time
set ruler

" Display incomplete commands
set showcmd

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax enable
  set background=dark
  colorscheme desert
  set guifont=DejaVu\ Sans\ Mono\ 11 
endif

" Set some reasonable defaults
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 72 characters.
  autocmd FileType text setlocal textwidth=72

  " For mail files set 'textwidth' to 72 characters.
  autocmd FileType mail setlocal textwidth=72 columns=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd BufReadPost fugitive://* set bufhidden=delete

  augroup END
else
  set autoindent    " always set autoindenting on
endif " has("autocmd")



" Wrap lines at 78 characters
set textwidth=78

" Highlighting search"
set hls

if has("gui_running")
  " GRB: set font"
  "set nomacatsui anti enc=utf-8 gfn=Monaco:h12

  " GRB: set window size"
  set lines=100
  set columns=88

  " GRB: highlight current line"
  set cursorline

  " GRB: hide the toolbar in GUI mode
  set go-=mT
endif

:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

" GRB: add pydoc command
:command! -nargs=+ Pydoc :call ShowPydoc("<args>")
function! ShowPydoc(module, ...)
    let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
    :execute ":!pydoc " . a:module . " > " . fPath
    :execute ":sp ".fPath
endfunction

" Always source python.vim for Python files
au FileType python run scripts/python.vim

au FileType cpp set et ci sts=4 sw=4 ts=4
au FileType cmp set et ci sts=4 sw=4 ts=4
au FileType conf set et ci sts=4 sw=4 ts=4

" Use custom python.vim syntax file
au! Syntax python run syntax/python.vim
let python_highlight_all = 1
let python_slow_sync = 1

" Use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" Put useful info in status line
set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<CR>/<BS>

if version >= 700
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    let Tlist_Ctags_Cmd='~/bin/ctags'
endif

let mapleader=","
nnoremap <leader><leader> <c-^>

" Highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=black

set cmdheight=2

set guioptions-=L
set guioptions=r

augroup myfiletypes
  "clear old autocmds in group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et
augroup END

set switchbuf=useopen

" Treat CMP files as CPP files (for SimCreator)
autocmd BufRead,BufNewFile *.cmp set ft=cpp

" Map ,e to open files in the same directory as the current file
map <leader>e :e <C-R>=expand("%:h")<cr>/

if has("python")
    run ropevim/rope.vim
endif

autocmd BufRead,BufNewFile *.feature set sw=4 sts=4 et

set number
set numberwidth=5

if has("gui_macvim")
  set guifont=Menlo\ Regular:h16
endif

" Use w!! to force writing of a file via sudo
cmap w!! w !sudo tee % >/dev/null


" Make window navigation easier
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
