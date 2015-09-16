colorscheme gruvbox
set background=dark
set encoding=utf-8
set guifont=Anonymous\ Pro\ for\ Powerline
set number
set foldcolumn=0
set expandtab
set tabstop=2
set shiftwidth=2
set showcmd
syntax on
filetype plugin indent on

augroup i_dont_like_folding
  autocmd!
  autocmd BufWinEnter * silent! :%foldopen!
augroup END

set noerrorbells visualbell t_vb=

set cursorline        " highlights line numbers (vim-airline-colornum)
" hi clear CursorLine " don't highlight the whole line though

" keeps vim swap files from interfering w/ boot-clj
set backup
set swapfile
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp

source ~/.vim_runtime/my_mappings.vim
source ~/.vim_runtime/my_iabbrevs.vim

