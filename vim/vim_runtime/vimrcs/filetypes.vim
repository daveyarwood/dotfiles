""""""""""""""""""""""""""""""
" => Python
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

" au FileType python map <buffer> F :set foldmethod=indent<cr>

" au FileType python inoremap <buffer> $r return
" au FileType python inoremap <buffer> $i import
" au FileType python inoremap <buffer> $p print
" au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
" au FileType python map <buffer> <leader>1 /class
" au FileType python map <buffer> <leader>2 /def
" au FileType python map <buffer> <leader>C ?class
" au FileType python map <buffer> <leader>D ?def


""""""""""""""""""""""""""""""
" => JavaScript
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

" au FileType javascript imap <c-t> $log();<esc>hi
" au FileType javascript imap <c-a> alert();<esc>hi

" au FileType javascript inoremap <buffer> $r return
" au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CoffeeScript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CoffeeScriptFold()
    setl foldmethod=indent
    setl foldlevelstart=1
endfunction
au FileType coffee call CoffeeScriptFold()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fish
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd Filetype fish compiler fish
autocmd Filetype fish setlocal textwidth=80
autocmd Filetype fish setlocal foldmethod=expr


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType gitcommit call setpos('.', [0, 1, 1, 0])


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => io
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup iolang
  au!
  " I have the 'extras/SyntaxHighlighters/Vim' directory of the IoLanguage/io
  " installed as a plugin, but it's just the syntax definition and that's it.
  " This line is necessary in order to actually recognize *.io files as Io
  " source files.
  au BufNewFile,BufRead *.io setlocal filetype=io
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lisp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup lisp
  au!
  au BufNewFile,BufRead *.asd setlocal filetype=lisp
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  "for some reason, I have to set the filetype to ghmarkdown, and then set it to markdown, in order to get all of the syntax highlighting. cool!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => help text
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
" => netrw
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
" => Clojure
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Strip off a symbol's namespace
function! SanitizeTag(word)
  return (split(a:word, '/')[-1])
endfunction

augroup clojure_and_hoplon
  autocmd!
  autocmd BufNewFile,BufRead  *.cljs.hl,*.boot set filetype=clojure
  autocmd BufNewFile,BufRead  *.html.hl        set filetype=html

  " When editing a Clojure(Script) buffer, make C-] smarter about jumping to
  " tags when the symbol is namespace-qualified.
  autocmd FileType clojure
        \ nnoremap <buffer> <C-]>
        \ :exe ":tag ".SanitizeTag(expand("<cword>"))<cr>
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Prolog
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup prolog
  autocmd!
  au BufNewFile,BufRead *.plt set syntax=prolog
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => C# / Spark MVC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup spark_mvc
  autocmd!
  autocmd BufNewFile,BufRead *.spark set filetype=html
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup golang
  " that thing you type every 2 seconds when you're programming in go
  " mnemonic: error propagate (ep)
  autocmd FileType go
        \ nnoremap <buffer> <localleader>ep
        \ :exe 'normal!' "oif err != nil {\<lt>cr>return err\<lt>cr>}"<cr>

  " 2-arity version of the above
  autocmd FileType go
        \ nnoremap <buffer> <localleader>eP
        \ :exe 'normal!' "oif err != nil {\<lt>cr>return nil, err\<lt>cr>}"<cr>
augroup END
