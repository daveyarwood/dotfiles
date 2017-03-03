colorscheme gruvbox
set background=dark
if !has('nvim')
  " nvim sets encoding to utf-8 by default
  set encoding=utf-8
endif
set guifont=Anonymous\ Pro\ for\ Powerline
set number
set foldcolumn=0
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=80
set cmdheight=1
set showcmd
set updatetime=250
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

" italic comments! https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
highlight Comment cterm=italic
set showtabline=0 " turn off tabline

" Go to the last edited file if I run `vim` without arguments.
autocmd VimEnter * nested if
  \ argc() == 0 &&
  \ bufname("%") == "" &&
  \ bufname("2" + 0) != "" |
  \   exe "normal! `0" |
  \ endif

" From vimrc_example.vim distributed with Vim 7.
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
