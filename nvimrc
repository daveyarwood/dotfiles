" neovim config

" everything in my vimrc works in neovim (even all the plugins!),
" so I just source my vimrc
source ~/.vimrc

" OPEN A FISH TERMINAL IN VIM, ZOMG
nnoremap <leader>F :terminal fish<CR>

" terminal mode -> normal mode
tnoremap <Esc> <C-\><C-n>
