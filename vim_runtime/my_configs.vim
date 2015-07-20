colorscheme gruvbox
set background=dark
set encoding=utf-8
set guifont=Anonymous\ Pro\ for\ Powerline
set number
set foldcolumn=0
set expandtab
set tabstop=2
set shiftwidth=2
syntax on
filetype plugin indent on
augroup i_dont_like_folding
  autocmd!
  au BufWinEnter * silent! :%foldopen!
augroup END

set noerrorbells visualbell t_vb=

set cursorline        " highlights line numbers (vim-airline-colornum)
" hi clear CursorLine " don't highlight the whole line though

" disable shortcut to go into Ex mode, which I never use
nnoremap Q <nop>

" the nuclear option - close everything without saving and quit
nnoremap <leader>Q :qa!<CR>

" why the fuck is it so hard to close netrw?
" I just want to press q
" augroup wtf_netrw
"   autocmd!
"   autocmd filetype netrw nnoremap <buffer> q :e#<CR>
" augroup END

" <CR> opens file in new tab (doesn't seem to work...)
" let g:netrw_browse_split = 3

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_time_format = "%b %d %Y %H:%M"

call vimfiler#custom#profile('default', 'context', {
      \   'safe': 0,
      \   'force_quit': 1
      \ })

let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify<Plug>PeepOpenroxy,extend-type,extend-protocol,letfn'
let g:clojure_align_multiline_strings = 1

let g:salve_auto_start_repl = 1

augroup clojure_and_hoplon
  autocmd!
  autocmd BufNewFile,BufRead  *.cljs.hl,*.boot set filetype=clojure
  autocmd BufNewFile,BufRead  *.html.hl        set filetype=html
augroup END

" Airline
let g:airline_theme = 'luna'                         " airline colorscheme
let g:airline_powerline_fonts = 1                    " Fancy symbols
let g:airline#extensions#tabline#enabled = 1         " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t'     " Show just the filename
let g:airline#extensions#tabline#tab_nr_type = 1     " Show buffer #, not # of splits
let g:airline#extensions#tabline#show_tab_nr = 1     " Show buffer # in tabline
let g:airline#extensions#tabline#show_tab_type = 1   " Show the tab type
let g:airline#extensions#tabline#buffer_idx_mode = 1 " Show buffer index

" keeps vim swap files from interfering w/ boot-clj
set backup
set swapfile
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp

let g:startify_custom_header = [
      \ '               ________________________________   ',  
      \ '              /    o   oooo ooo oooo   o o o  /\  ',  
      \ '             /    oo  ooo  oo  oooo   o o o  / /  ',  
      \ '            /    _________________________  / /   ',  
      \ '           / // / // /// // /// // /// / / / /    ',  
      \ '          /___ //////////////////////////_/ /     ',  
      \ '          \____\________________________\_\/      ',
      \ '',
      \ '',
      \ ]

let g:startify_custom_indices = ['a', 'o', 'u', 'd', 'n', 'p', 'g', 'c', 'r', 'y', 'f', 'x', 'm', 'w', 'z', 'A', 'O', 'E', 'U', 'H', 'T', 'N', 'S', 'I', 'D', 'P', 'G', 'C', 'R', 'L', 'Y', 'F', 'Q', 'J', 'K', 'B', 'W', 'V', 'Z', 'X']

let g:startify_enable_special = 0

let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki', 'path_html': '~/Dropbox/vimwiki/html'}]

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

let g:paredit_leader = '\'

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|^.git$\|_site'

nnoremap ga :UnicodeName<CR>

" remap leader key to ,
let mapleader = ","

nnoremap <leader>s :source ~/.vim_runtime/my_configs.vim<CR>
nnoremap <leader>p :e! ~/.vimrc<CR>

" gimme a fish shell! (exit / ^D to return to vim)
" nnoremap <leader>t :!fish<CR>

" 'skip a line' variants of o/O
nnoremap <leader>o o<CR>
nnoremap <leader>O O<Esc>O
" append & prepend blank lines and go into insert mode
nnoremap <C-o> o<Esc>O

" like J (which appends next line to current line),
" but works the other way (appends current line to previous line)
nnoremap <C-j> kJ

" jump to the end of a sexp and be in insert mode
nnoremap <Bslash>a f)i 

" shortcuts for switching tabs, etc.
nnoremap <leader>h :bp<CR>
nnoremap H :bp<CR>
nnoremap <leader>l :bn<CR>
nnoremap L :bn<CR>
nnoremap <leader>, :b#<CR>
nnoremap <leader>d :bp <BAR> bd #<CR>
nnoremap Q :bp <BAR> bd #<CR>
nnoremap <leader>dd :bp <BAR> bd! #<CR>
" creates an empty buffer and closes everything else 
" (doesn't close any buffers with unsaved changes)
nnoremap <leader>c :enew<CR>:BufOnly<CR>

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

nmap <leader>f <Plug>CtrlSFPrompt
vmap <leader>f <Plug>CtrlSFVwordExec

nnoremap <leader>r :Require!<CR>
nnoremap <leader>t :RunTests<CR>

" insert 80 semicolons (useful as a make-shift <hr> in Clojure files)
nnoremap <leader>; 80i;<Esc> 

