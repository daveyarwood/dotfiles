" remap leader key to ,
let mapleader = ","

" disable shortcut to go into Ex mode, which I never use
nnoremap Q <nop>

" the nuclear option - close everything without saving and quit
nnoremap <leader>Q :qa!<CR>

nnoremap ga :UnicodeName<CR>

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
nnoremap <Space>j kJ

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

" copy & paste to system clipboard
nnoremap <Space>y "*y
vnoremap <Space>y "*y
nnoremap <Space>d "*d
vnoremap <Space>d "*d
nnoremap <Space>p "*p
vnoremap <Space>p "*p
nnoremap <Space>P "*P
vnoremap <Space>P "*P

" Enter -> go to last line
" (bonus: 12<Enter> -> go to line 12)
nnoremap <CR> G
" Backspace -> go to first line
nnoremap <BS> gg

" strip whitespace (via vim-better-whitespace)
nnoremap <leader><Space> :StripWhitespace<CR>
