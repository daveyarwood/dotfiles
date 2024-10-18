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

" disable shortcut to go into Ex mode, which I never use
nnoremap Q <nop>

" the nuclear option - close everything without saving and quit
nnoremap <leader>Q :qa!<CR>

" i'm constantly accidentally typing :Q instead of :q when I want to quit
" let's just make :Q quit too
command! Q q

" Disable highlight
map <silent> <leader><cr> :noh<cr>

nnoremap <leader>ec :e! ~/.vim/custom/<cr>
nnoremap <leader>ef :e! ~/.vim/custom/300-filetypes.vim<cr>
nnoremap <leader>el :e! ~/.config/nvim/lua/user/<cr>
nnoremap <leader>em :e! ~/.vim/custom/400-mappings.vim<cr>
nnoremap <leader>ep :e! ~/.vim/custom/100-plugins.vim<cr>
nnoremap <leader>eP :e! ~/.vim/custom/500-plugins-config.vim<cr>
nnoremap <leader>ev :e! ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

" Project-specific
nnoremap <leader>ld :e! ~/code/spark/config/src/env/local-development.js<cr>

" 'skip a line' variants of o/O
nnoremap <leader>o o<CR>
nnoremap <leader>O O<Esc>O
" append & prepend blank lines and go into insert mode
nnoremap <C-o> o<Esc>O
