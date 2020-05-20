""""""""""""""""""""""""""""""
" => Python
""""""""""""""""""""""""""""""
let python_highlight_all = 1

augroup python_filetype_settings
  autocmd!
  autocmd FileType python syn keyword pythonDecorator True None False self
  autocmd BufNewFile,BufRead *.jinja set syntax=htmljinja
  autocmd BufNewFile,BufRead *.mako set ft=mako
augroup END


""""""""""""""""""""""""""""""
" => JavaScript
"""""""""""""""""""""""""""""""
function! JavaScriptFold() abort
  setl foldmethod=syntax
  setl foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  function! FoldText() abort
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction
  setl foldtext=FoldText()
endfunction

augroup javascript_filetype_settings
  autocmd!
  autocmd FileType javascript call JavaScriptFold()
  autocmd FileType javascript setl fen
  autocmd FileType javascript setl nocindent
augroup END


""""""""""""""""""""""""""""""
" => JSON
"""""""""""""""""""""""""""""""
" magically format/minify json in the current buffer
nnoremap <leader>jf :%!jq '.'<CR>
nnoremap <leader>jm :%!jq -c '.'<CR>
" or just the current visual selection
vnoremap <leader>jf :!jq '.'<CR>
vnoremap <leader>jm :!jq -c '.'<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CoffeeScript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CoffeeScriptFold() abort
  setl foldmethod=indent
  setl foldlevelstart=1
endfunction

augroup coffeescript_filetype_settings
  autocmd!
  autocmd FileType coffee call CoffeeScriptFold()
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fish
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup fish_filetype_settings
  autocmd!
  autocmd Filetype fish compiler fish
  autocmd Filetype fish setlocal textwidth=80
  autocmd Filetype fish setlocal foldmethod=expr
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup git_buffer_settings
  autocmd!
  autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => io
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup iolang
  autocmd!
  " I have the 'extras/SyntaxHighlighters/Vim' directory of the IoLanguage/io
  " installed as a plugin, but it's just the syntax definition and that's it.
  " This line is necessary in order to actually recognize *.io files as Io
  " source files.
  autocmd BufNewFile,BufRead *.io setlocal filetype=io
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lisp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup lisp
  autocmd!
  autocmd BufNewFile,BufRead *.asd setlocal filetype=lisp
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup markdown
  autocmd!
  autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  "for some reason, I have to set the filetype to ghmarkdown, and then set it to markdown, in order to get all of the syntax highlighting. cool!
  autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => help text
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup help_text
  autocmd!
  autocmd BufEnter *.txt call s:at_help()
augroup END

function! s:at_help() abort
  if &buftype == 'help'
    " enable 'q' = quit
    nnoremap <buffer> q :q<CR>
  endif
endfunction



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => quickfix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Press q to close quickfix buffer.
augroup quickfix_settings
  autocmd!
  autocmd BufReadPost quickfix nnoremap <buffer> q :q!<CR>
augroup END


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
function! SanitizeTag(word) abort
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
  autocmd BufNewFile,BufRead *.plt set syntax=prolog
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
  autocmd!
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Alda
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Replaces each part call in the score (e.g. `piano:`) with a random instrument.
" This is useful for when I'm writing demo scores and I want to keep things
" interesting instead of just using the same instruments over and over again.
"
" NB: This isn't perfect. It doesn't properly handle:
" * Colons within comments or inline Clojure expressions.
" * Instrument groups, e.g. clarinet/flute/oboe:
" * Part aliases, e.g. piano "foo":, trumpet/trombone "bar":
function! RandomizeAldaInstruments() abort
  let instruments = trim(system("mktemp"), "\n")
  exe "!alda instruments > " . instruments
  exe '%s/[[:alnum:]-]\+:/\=trim(system("shuf -n1 '
        \ . escape(instruments, "/")
        \ . '"), "\n") . ":"/gc'
endfunction

augroup alda
  autocmd!
  autocmd FileType alda
        \ nnoremap <buffer> <silent> <localleader>ri
        \ :call RandomizeAldaInstruments()<cr>
augroup END
