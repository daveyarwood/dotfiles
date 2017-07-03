""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def


""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> $log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""
" => CoffeeScript section
"""""""""""""""""""""""""""""""
function! CoffeeScriptFold()
    setl foldmethod=indent
    setl foldlevelstart=1
endfunction
au FileType coffee call CoffeeScriptFold()

au FileType gitcommit call setpos('.', [0, 1, 1, 0])


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fish section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd Filetype fish compiler fish
autocmd Filetype fish setlocal textwidth=79
autocmd Filetype fish setlocal foldmethod=expr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => markdown section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  "for some reason, I have to set the filetype to ghmarkdown, and then set it to markdown, in order to get all of the syntax highlighting. cool!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => help text section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup help_text
  autocmd!
  autocmd BufEnter *.txt call s:at_help()
augroup END

function! s:at_help()
  if &buftype == 'help'
    " enable 'q' = quit
    nnoremap <buffer> q :q<CR>
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => netrw section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" why the fuck is it so hard to close netrw?
" I just want to press q
" augroup wtf_netrw
"   autocmd!
"   autocmd filetype netrw nnoremap <buffer> q :e#<CR>
" augroup END

" <CR> opens file in new tab (doesn't seem to work...)
" let g:netrw_browse_split = 3


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clojure section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup clojure_and_hoplon
  autocmd!
  autocmd BufNewFile,BufRead  *.cljs.hl,*.boot set filetype=clojure
  autocmd BufNewFile,BufRead  *.html.hl        set filetype=html
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Prolog section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup prolog
  autocmd!
  au BufNewFile,BufRead *.plt set syntax=prolog
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => C# / Spark MVC section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup csharp
  autocmd!
  autocmd Filetype cs setlocal shiftwidth=4
augroup END

augroup spark_mvc
  autocmd!
  autocmd BufNewFile,BufRead *.spark set filetype=html
augroup END