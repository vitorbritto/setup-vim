
" Add the variable with the name a:varName to the statusline. Highlight it as
" 'error' unless its value is in a:goodValues (a comma separated string)
function! AddStatuslineFlag(varName, goodValues)
  set statusline+=[
  set statusline+=%#error#
  exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',1)}"
  set statusline+=%*
  exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',0)}"
  set statusline+=]
endfunction

" returns a:value or ''
" a:goodValues is a comma separated string of values that shouldn't be highlighted with the error group
" a:error indicates whether the string that is returned will be highlighted as 'error'
function! RenderStlFlag(value, goodValues, error)
  let goodValues = split(a:goodValues, ',')
  let good = index(goodValues, a:value) != -1
  if (a:error && !good) || (!a:error && good)
    return a:value
  else
    return ''
  endif
endfunction

" return '[&et]' if &et is set wrong
" return '[mixed-indenting]' if spaces and tabs are used to indent
" return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0
        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

" return '[\s]' if trailing white space is detected
" return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

" Fancy statusline.
set statusline=%t                                   "tail of the filename
set statusline+=%m                                  "modified flag
" call AddStatuslineFlag('&ff', 'unix')             "fileformat
" call AddStatuslineFlag('&fenc', 'utf-8')          "file encoding
set statusline+=%h                                  "help file flag
set statusline+=%r                                  "read only flag
set statusline+=%y                                  "filetype

" Syntastic plugin warnings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" From Fugitive plugin
set statusline+=%{fugitive#statusline()}

" Show the rubies courtesty of rvm.vim
set statusline+=%{rvm#statusline()}

set statusline+=%#error#                            "display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%{StatuslineTabWarning()}           "warnings for mixed tabs and other issues
set statusline+=%{StatuslineTrailingSpaceWarning()} "warning if there is any trailing whitespace
set statusline+=%*
set statusline+=%=                                  "left/right separator
set statusline+=%c,                                 "cursor column
set statusline+=%l/%L                               "cursor line/total lines
set statusline+=\ %p                                "percent through file

" recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

" recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

