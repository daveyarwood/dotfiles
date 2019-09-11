" terminal color / italics finagling
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
highlight Comment cterm=italic

let g:colorscheme_mode = v:null

" i use this theme most of the time
function! s:DarkMode() abort
  let g:colorscheme_mode = 'dark'
  let g:gruvbox_italic=1
  set background=dark
  colorscheme gruvbox
  " let ayucolor="dark"
  " colorscheme ayu
  let g:lightline.colorscheme = 'onehalfdark'
  call lightline#disable()
  call lightline#enable()
endfunction
command! DarkMode call s:DarkMode()

" a decent looking light theme to use when giving demos, etc.
function! s:LightMode() abort
  let g:colorscheme_mode = 'light'
  set background=light
  " 0 = low, 1 = medium, 2 = high visibility; i think medium looks best
  let g:mayansmoke_cursor_line_visibility = 1
  colorscheme mayansmoke
  let g:lightline.colorscheme = 'solarized'
  call lightline#disable()
  call lightline#enable()
endfunction
command! LightMode call s:LightMode()

function! s:ToggleColorschemeMode() abort
  if g:colorscheme_mode ==# 'dark'
    call s:LightMode()
  else
    call s:DarkMode()
  endif
endfunction
command! ToggleColorschemeMode call s:ToggleColorschemeMode()
nnoremap <leader>M :ToggleColorschemeMode<CR>

" Start in dark mode
call s:DarkMode()

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
