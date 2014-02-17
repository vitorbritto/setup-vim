
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
set noerrorbells                           " No noise

if has("gui_running")
    set go-=T                              " hide the toolbar
    set go-=m                              " hide the menu
    set go-=rRlLbh                         " hide all the scrollbars
    set mouse=a                            " Automatically enable mouse usage
    set mousehide                          " Hide the mouse cursor while typing
endif

set backspace=indent,eol,start
set undofile

set splitbelow splitright                  " Open new split panes to right and bottom, which feels more natural

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

"statusline setup
set statusline =%#identifier#
set statusline+=[%t]    "tail of the filename
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

"modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

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

" F1 - Terminal
map <F1> :Terminal<CR>

" F2 - NERDTree
nnoremap <F2> :NERDTreeToggle<CR>

" F3 - GundoTree
nnoremap <F3> :GundoToggle<CR>


"  ---------------------------------------------------------------------------
"  Auto Commands
"  ---------------------------------------------------------------------------

au vimenter * NERDTree

au BufNewFile *.txt :write

au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setlocal spell                " Enable spellchecking for Markdown
au BufRead,BufNewFile *.md setlocal textwidth=80   " Automatically wrap at 80 characters for Markdown

au! BufRead,BufNewFile *.sass setfiletype sass
au BufRead,BufNewFile *.scss set filetype=scss
au BufNewFile,BufReadPost *.scss setl foldmethod=indent
au BufNewFile,BufReadPost *.sass setl foldmethod=indent


"  ---------------------------------------------------------------------------
"  Plugins
"  ---------------------------------------------------------------------------

" NerdTree {

    map <C-n> :NERDTreeToggle<CR>               " Open NERDTree
    map <C-e> <plug>NERDTreeTabsToggle<CR>      " Toggle tabs
    map <leader>e :NERDTreeFind<CR>             " NERDTree Find
    nmap <leader>nt :NERDTreeFind<CR>

    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    let NERDTreeShowBookmarks = 0
    let NERDChristmasTree = 1
    let NERDTreeWinPos = "left"
    let NERDTreeHijackNetrw = 1
    let NERDTreeQuitOnOpen = 1
    let NERDTreeWinSize = 50
    let NERDTreeChDirMode = 2
    let NERDTreeDirArrows = 1
    let NERDTreeMouseMode=2

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
    let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
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

