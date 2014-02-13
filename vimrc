
" Disable vi compatibility
set nocompatible

" Use Pathogen to load bundles
execute pathogen#infect()

"  ---------------------------------------------------------------------------
"  General
"  ---------------------------------------------------------------------------

filetype plugin indent on
let mapleader = ","
let g:mapleader = ","
set modelines=0
set history=1000
set nobackup
set nowritebackup
set noswapfile
syntax on
set autoread

"  ---------------------------------------------------------------------------
"  UI
"  ---------------------------------------------------------------------------

set title
set encoding=utf-8
set scrolloff=3
set autoindent
set smartindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set undofile
set splitbelow splitright

set number
set relativenumber

set foldenable                " Turn on folding
set foldmethod=marker         " Fold on the marker
set foldlevel=100             " Don't autofold anything (but I can still fold manually)

set foldopen=block,hor,tag    " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

" Auto adjust window sizes when they become current
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

" Theme and Font Settings
colorscheme molokai
set guifont=Menlo:h14
set t_Co=256
set linespace=8

" Use relative line numbers
if exists("&relativenumber")
    set relativenumber
    au BufReadPost * set relativenumber
endif

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>


"  ---------------------------------------------------------------------------
"  Directories - Centralize backups, swapfiles and undo history
"  ---------------------------------------------------------------------------

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif


"  ---------------------------------------------------------------------------
"  Text Formatting
"  ---------------------------------------------------------------------------

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set nowrap
set textwidth=79
set formatoptions=n


"  ---------------------------------------------------------------------------
"  Status Line
"  ---------------------------------------------------------------------------

" path
set statusline=%f
" flags
set statusline+=%m%r%h%w
" git branch
set statusline+=\ %{fugitive#statusline()}
" encoding
set statusline+=\ [%{strlen(&fenc)?&fenc:&enc}]
" rvm
set statusline+=\ %{rvm#statusline()}
" line x of y
set statusline+=\ [line\ %l\/%L]

" Colour
hi StatusLine ctermfg=Black ctermbg=White

" Change colour of statusline in insert mode
au InsertEnter * hi StatusLine ctermbg=DarkBlue
au InsertLeave * hi StatusLine ctermfg=Black ctermbg=White


"  ---------------------------------------------------------------------------
"  Mappings
"  ---------------------------------------------------------------------------

" Saving and exit
nmap <leader>q :wqa!<CR>
nmap <leader>w :w!<CR>
nmap <leader><Esc> :q!<CR>


"  ---------------------------------------------------------------------------
"  Abbreviations
"  ---------------------------------------------------------------------------

iabbrev @@    code@vitorbritto.com.br
iabbrev ccopy Copyright 2014 Vitor Britto. All rights reserved.


"  ---------------------------------------------------------------------------
"  Function Keys
"  ---------------------------------------------------------------------------

" F2 - Terminal
map <F2> :Terminal<CR>

" F3 - toggle GUndo tree
nnoremap <F3> :GundoToggle<CR>

" F4 - indent file and return cursor and center cursor
map   <silent> <F4> mmgg=G`m^zz
imap  <silent> <F4> <Esc> mmgg=G`m^zz


"  ---------------------------------------------------------------------------
"  Auto Commands
"  ---------------------------------------------------------------------------

" Automatic commands
if has("autocmd")
    filetype on
    autocmd BufNewFile *.txt :write
endif




"  ---------------------------------------------------------------------------
"  Plugins
"  ---------------------------------------------------------------------------

let NERDSpaceDelims=1
let NERDTreeIgnore=['.DS_Store']
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_disabled_filetypes = ['scss']

" Popup menu behavior
set completeopt=longest,menu
set pumheight=20

" Setup supertab to be a bit smarter about it's usage
" let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabLongestEnhanced = 1

" Tell snipmate to pull it's snippets from a custom directory
let g:snippets_dir = $HOME.'/.vim/snippets/'
