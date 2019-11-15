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

set showtabline=0 " turn off tabline

" Go to last file(s) if invoked without arguments.
autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
    \ call mkdir($HOME . "/.vim") |
    \ endif |
    \ execute "mksession! " . $HOME . "/.vim/Session.vim"

autocmd VimEnter * nested if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
    \ execute "source " . $HOME . "/.vim/Session.vim"

" Turn persistent undo on (means that you can undo even when you close a
" buffer/VIM)
if has('persistent_undo')
  set undodir=~/.vim_runtime/temp_dirs/undodir
  set undofile
endif

