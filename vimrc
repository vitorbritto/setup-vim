
" Disable vi compatibility
set nocompatible

" Use Pathogen to load bundles
execute pathogen#infect()

"  ---------------------------------------------------------------------------
"  General
"  ---------------------------------------------------------------------------

filetype plugin indent on           " Automatically detect file types.let mapleader = ","
let g:mapleader = ","               " Change mapleader

set modeline                        " Respect modeline in files
set modelines=3

set history=1000                    " Store a ton of history (default is 20)
syntax on                           " Syntax highlighting
set mouse=a                         " Automatically enable mouse usage
set mousehide                       " Hide the mouse cursor while typing
set autoread                        " Update an open file edited outside of Vim
set autowrite                       " Automatically :write before running commands
set shell=bash                      " Run RVM inside VIM
set ttyfast                         " Optimize for fast terminal connections


"  ---------------------------------------------------------------------------
"  UI
"  ---------------------------------------------------------------------------

set title                                  " Show the filename in the window titlebar
set encoding=utf-8                         " Use UTF-8
set scrolloff=3                            " Start scrolling three lines before the horizontal window border
set autoindent
set smartindent
set showmode                               " Show the current mode
set tabpagemax=15                          " Only show 15 tabs
set hidden
set wildmenu                               " Show list instead of just completing
set wildmode=list:longest,full             " Command <Tab> completion, list matches, then longest common part, then all.

set novisualbell                           " No blinking
set noerrorbells                           " No noise.

set virtualedit=block

set guioptions-=m                          "remove menu bar
set guioptions-=T                          "remove toolbar
set guioptions-=r                          "remove right-hand scroll bar
set guioptions-=L                          "remove left-hand scroll bar

set backspace=indent,eol,start
set laststatus=2                           " Always show status line
set undofile

set splitbelow                             " Open new split panes to right and bottom, which feels more natural
set splitright

set number                                 " Line numbers on
set numberwidth=5

set cursorline
set ruler                                            " Show the ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)   " A ruler on steroids
set showcmd                                          " Show partial commands in status line and
                                                     " selected characters/lines in visual mode

set foldenable                                       " Turn on folding
set foldmethod=marker                                " Fold on the marker
set foldlevel=100                                    " Don't autofold anything (but I can still fold manually)

set foldopen=block,hor,tag                           " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.       " Highlight problematic whitespace
set hlsearch                                         " Highlight searches
set ignorecase                                       " Ignore case of searches
set incsearch                                        " Highlight dynamically as pattern is typed

set lines=50 columns=180                             " Auto adjust window sizes when they become current

colorscheme molokai                                  " Theme and Font Settings
set guifont=Menlo:h14
set t_Co=256
set linespace=8


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

set tabstop=4                     " Make tabs as wide as four spaces
set shiftwidth=4
set softtabstop=4
set expandtab

set textwidth=80
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

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Opens files in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

noremap <leader>ss :call StripWhitespace()<CR>


"  ---------------------------------------------------------------------------
"  Helpers
"  ---------------------------------------------------------------------------

function! MakeDirIfNoExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path), "p")
    endif
endfunction

" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction


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

augroup vimrcEx
    autocmd!
    autocmd vimenter * NERDTree

    autocmd BufNewFile *.txt :write

    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd FileType markdown setlocal spell                " Enable spellchecking for Markdown
    autocmd BufRead,BufNewFile *.md setlocal textwidth=80   " Automatically wrap at 80 characters for Markdown

    autocmd! BufRead,BufNewFile *.sass setfiletype sass
augroup END

"  ---------------------------------------------------------------------------
"  Plugins
"  ---------------------------------------------------------------------------

" NerdTree {

    map <C-n> :NERDTreeToggle<CR>               " Open NERDTree
    map <C-e> <plug>NERDTreeTabsToggle<CR>      " Toggle tabs
    map <leader>e :NERDTreeFind<CR>             " NERDTree Find
    nmap <leader>nt :NERDTreeFind<CR>

    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=0
    let g:nerdtree_tabs_open_on_gui_startup=0
" }


" Synstatic {
    let g:syntastic_check_on_open=1                " Configure Synstatic syntax checking to check on open as well as save
    let g:syntastic_error_symbol='✗'               " Configure Synstatic error symbol
    let g:syntastic_style_error_symbol  = '⚡'
    let g:syntastic_warning_symbol='⚠'             " Configure Synstatic warning symbol
    let g:syntastic_style_warning_symbol  = '⚡'
" }

" AirLine {
    let g:airline_theme='powerlineish'
    let g:airline_enable_branch=1
    let g:airline_powerline_fonts=1
    let g:airline_detect_whitespace = 1
    let g:airline#extensions#hunks#non_zero_only = 1
" }

" Supertab {
    " let g:SuperTabDefaultCompletionType = 'context'
    let g:SuperTabLongestEnhanced = 1
" }

" Snipmate {
    " Tell snipmate to pull it's snippets from a custom directory
    let g:snippets_dir = '~/.vim/snippets/'
" }

" Fugitive {
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
" }

" Gundo {
    nnoremap <Leader>u :GundoToggle<CR>
    let g:gundo_preview_bottom = 1
" }

