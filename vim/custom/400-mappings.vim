" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Remap VIM 0 to first non-blank character
map 0 ^

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Fast saving
nmap <C-s> :w!<cr>
nmap <C-x> :x!<cr>
imap <C-s> <Esc><C-s>
imap <C-x> <Esc><C-x>

" FIXME: <C-X> is actually the same key code as <C-x>! Apparently the terminal
" sends the same key code, so there is no way to differentiate. I'm just
" commenting this out for now.
"
" TODO: Either get rid of this (maybe I don't want it after all) or come up with
" a different keybinding.
"
" For when I'm feeling extra-confident: save commit and immediately git push
" nmap <silent> <C-X> :call SaveCommitAndPush()<cr>
" function! SaveCommitAndPush() abort
"   x!
"   Gina push
"   Gina status
" endfunction

" disable shortcut to go into Ex mode, which I never use
nnoremap Q <nop>

" the nuclear option - close everything without saving and quit
nnoremap <leader>Q :qa!<CR>

" i'm constantly accidentally typing :Q instead of :q when I want to quit
" let's just make :Q quit too
command! Q q

" Disable highlight
map <silent> <leader><cr> :noh<cr>

nnoremap <leader>ec :Defx ~/.vim/custom/<cr>
nnoremap <leader>em :e! ~/.vim/custom/400-mappings.vim<cr>
nnoremap <leader>ep :e! ~/.vim/custom/100-plugins.vim<cr>
nnoremap <leader>eP :e! ~/.vim/custom/500-plugins-config.vim<cr>
nnoremap <leader>ev :e! ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

" 'skip a line' variants of o/O
nnoremap <leader>o o<CR>
nnoremap <leader>O O<Esc>O
" append & prepend blank lines and go into insert mode
nnoremap <C-o> o<Esc>O

" like J (which appends next line to current line),
" but works the other way (appends current line to previous line)
nnoremap <Space>j kJ
