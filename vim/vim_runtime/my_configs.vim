" terminal color / italics finagling
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
highlight Comment cterm=italic

" color theme
let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark
" let ayucolor="dark"
" colorscheme ayu

if !has('nvim')
  " nvim sets encoding to utf-8 by default
  set encoding=utf-8
endif
set number
set foldcolumn=0
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=80
set cmdheight=1
set showcmd
set updatetime=250

augroup i_dont_like_folding
  autocmd!
  autocmd BufWinEnter * silent! :%foldopen!
augroup END

set noerrorbells visualbell t_vb=

set cursorline        " highlights line numbers (vim-airline-colornum)
" hi clear CursorLine " don't highlight the whole line though

set noswapfile

source ~/.vim_runtime/my_mappings.vim
source ~/.vim_runtime/my_iabbrevs.vim

set showtabline=0 " turn off tabline

" Go to last file(s) if invoked without arguments.
autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
    \ call mkdir($HOME . "/.vim") |
    \ endif |
    \ execute "mksession! " . $HOME . "/.vim/Session.vim"

autocmd VimEnter * nested if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
    \ execute "source " . $HOME . "/.vim/Session.vim"
