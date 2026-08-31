" neovim config

" everything in my vimrc works in neovim (even all the plugins!),
" so I just source my vimrc
source ~/.vimrc

" When I open a terminal buffer, I want it to feel like I'm in the terminal. I
" don't want to still be in normal mode.
autocmd TermOpen * startinsert

" This doesn't play nice with Conjure, which will sometimes open a terminal
" buffer to start a REPL server and then switch back to the previous
" buffer.
"
" As a workaround, I explicitly switch to normal mode when entering any
" Clojure buffer.
autocmd BufEnter *.clj,*.cljs,*.edn stopinsert
" (This doesn't work, for some reason.)
" autocmd FileType clojure stopinsert

" When Escape is pressed while in Terminal mode, enter Normal mode.
tnoremap <silent> <esc> <C-\><C-n><CR>

" " required for python remote plugins
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
