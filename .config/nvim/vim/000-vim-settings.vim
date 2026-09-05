" I use fish shell, but some vim plugins, including vim-fzf don't seem to work
" properly unless shell=bash.
set shell=bash

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Fixes occasional issues where Vim disables syntax highlighting because
" some plugin takes more than the default of 2 seconds to redraw the screen.
"
" See: https://github.com/vim/vim/issues/2790
set redrawtime=10000

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Enable syntax highlighting
syntax enable
" Used by vimwiki
syntax on

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" 80 chars or die
set textwidth=80

" Automatically break lines at 80 characters.
set lbr

set autoindent
set wrap "Wrap lines

" Return to last edit position when opening files (You want this!)
augroup return_to_last_edit_position
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2

" Returns true if paste mode is enabled
function! HasPaste() abort
  if &paste
    return 'PASTE MODE  '
  en
  return ''
endfunction

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

if !has('nvim')
  " nvim sets encoding to utf-8 by default
  set encoding=utf-8
endif

set number
set foldcolumn=0
set cmdheight=1
set showcmd
set updatetime=250

augroup i_dont_like_folding
  autocmd!
  autocmd BufWinEnter * silent! :%foldopen!
augroup END

" remap leader key to ,
let mapleader = ","
let g:mapleader = ","

" highlights line numbers (vim-airline-colornum)
set cursorline

" turn off tabline
set showtabline=0

" This makes it so that when you press certain keybindings that jump you to a
" new line, like gg, G, <C-d> and <C-u>, your cursor lands on column 1 instead
" of staying in the same column.
"
" This option is on by default in Vim, but Neovim annoyingly changed the default
" to off in December 2019. I was used to the default behavior, so I'm turning it
" on explicitly.
set startofline

" Go to last file(s) if Vim is started without arguments.
augroup reopen_last_file
  autocmd!
  autocmd VimLeave * nested
        \ if (!isdirectory($HOME . "/.vim")) |
        \ call mkdir($HOME . "/.vim") |
        \ endif |
        \ execute "mksession! " . $HOME . "/.vim/Session.vim"
  autocmd VimEnter * nested
        \ if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
        \ execute "source " . $HOME . "/.vim/Session.vim"
augroup END

" Turn persistent undo on (means that you can undo even when you close a
" buffer/VIM)
if has('persistent_undo')
  set undodir=~/.vim_runtime/temp_dirs/undodir
  set undofile
endif

" The default timeoutlen is 1000 ms.
set timeoutlen=500
