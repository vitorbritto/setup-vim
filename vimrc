
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
"  Basic Options
"  ---------------------------------------------------------------------------

set showcmd                                             " Show partial commands in status line
set showmode                                            " Show the current mode
set backspace=indent,eol,start
set hidden
set wildmenu                                            " Show list instead of just completing
set wildmode=list:longest,full                          " Command <Tab> completion, list matches, then longest common part, then all.
set ignorecase                                          " Ignore case of searches
set smartcase
set number                                              " Line numbers on
set ruler                                               " Show the ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)      " A ruler on steroids
set hlsearch                                            " Highlight searches
set incsearch                                           " Highlight dynamically as pattern is typed
set nowrap
set scrolloff=3
set title                                               " Show the filename in the window titlebar
set novisualbell                                        " No blinking
set noerrorbells                                        " No noise
set cursorline
set foldenable                                          " Turn on folding
set foldmethod=indent                                   " Fold on the indent
set foldlevel=100                                       " Don't autofold anything (but I can still fold manually)
set foldopen=block,hor,tag                              " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.          " Highlight problematic whitespace
set tabpagemax=15                                       " Only show 15 tabs
set undofile
set splitbelow splitright                               " Open new split panes to right and bottom, which feels more natural
set t_Co=256



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

" Tabs
nnoremap <leader>t :tabnew<cr>
nnoremap <leader>e :tabedit
nnoremap <leader>c :tabclose<cr>
nnoremap <leader>n :tabnext<cr>
nnoremap <leader>p :tabprevious<cr>

" Go to start of line with H and to the end with L
noremap H ^
noremap L $

" Move around easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Create windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>m <C-w>s<C-w>j
nnoremap <leader>d <C-w>q

" Saving and Exit
nmap <leader>q :wqa!<CR>
nmap <leader>w :w!<CR>
nmap <leader><Esc> :q!<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Opens files in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" Execute StripWhitespace Function
noremap <leader>ss :call StripWhitespace()<CR>

" Execute RenameFile Function
map <leader>rn :call RenameFile()<cr>

" Execute MakeDirIfNoExists Function
" map <leader>mk :call MakeDirIfNoExists()<cr>

" Go full-screen
nnoremap <leader>fs :set lines=999 columns=9999<cr>



"  ---------------------------------------------------------------------------
"  Helpers
"  ---------------------------------------------------------------------------

" function! MakeDirIfNoExists(path)
"     if !isdirectory(expand(a:path))
"         call mkdir(expand(a:path), "p")
"     endif
" endfunction

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
iabbrev ccopy Copyright 2015 Vitor Britto. All rights reserved.



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

autocmd vimenter * NERDTree

autocmd BufRead,BufNewFile *.txt set filetype=markdown
autocmd BufNewFile *.txt :write
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd FileType markdown set spell
autocmd BufRead,BufNewFile *.md set wrap

autocmd BufRead,BufNewFile *.php set filetype=php

autocmd BufRead,BufNewFile *.js set filetype=javascript syntax=javascript
autocmd BufRead,BufNewFile *.json set filetype=json syntax=javascript
autocmd BufRead,BufNewFile *.jade set filetype=html
autocmd BufRead,BufNewFile *.ejs set filetype=html

autocmd BufRead,BufNewFile *.sass set filetype=sass
autocmd BufRead,BufNewFile *.scss set filetype=scss
autocmd BufNewFile,BufReadPost *.scss set foldmethod=indent
autocmd BufNewFile,BufReadPost *.sass set foldmethod=indent
autocmd BufRead,BufNewFile *.yml set filetype=yaml
autocmd BufRead,BufNewFile *.rb set filetype=ruby
autocmd FileType ruby set shiftwidth=2
autocmd FileType ruby set tabstop=2
autocmd FileType eruby set shiftwidth=4
autocmd FileType eruby set tabstop=4



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
    let NERDTreeWinSize = 30
    let NERDTreeChDirMode = 2
    let NERDTreeDirArrows = 1
    let NERDTreeMouseMode=2

" }


" CtrlP {

    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|sass-cache|node_modules)$',
      \ 'file': '\v\.(DS_Store)$'
      \ }

" }


" Synstatic {

    let g:syntastic_check_on_open = 1             " Check on open as well as save
    let g:syntastic_error_symbol = '✗'            " Error Symbol
    let g:syntastic_warning_symbol = '⚠'          " Warning Symbol
    let g:syntastic_style_error_symbol = '⚡'      " Style Error Symbol
    let g:syntastic_style_warning_symbol = '⚡'    " Style Warning Symbol

    let g:syntastic_css_checkers = ['csslint']
    let g:syntastic_javascript_checkers = ['jshint']

" }


" AirLine {

    let g:airline_theme='powerlineish'
    let g:airline_enable_branch = 1
    let g:airline_powerline_fonts = 1
    let g:airline_detect_whitespace = 1
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline_section_warning = ''
    let g:airline_inactive_collapse = 0
    let g:airline#extensions#default#section_truncate_width = {
    \ 'a': 60,
    \ 'b': 80,
    \ 'x': 100,
    \ 'y': 100,
    \ 'z': 60,
    \ }

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
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>

" }


" Gundo {

    nnoremap <Leader>u :GundoToggle<CR>
    let g:gundo_preview_bottom = 1

" }
