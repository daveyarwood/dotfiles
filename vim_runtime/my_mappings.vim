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

" Prompt for a command to be run in a 20% lower tmux split, witohut losing
" focus on vim :)
nnoremap <leader>v :VimuxPromptCommand<CR>

" Close vimux runner window
nnoremap <leader>V :VimuxCloseRunner<CR>

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

" magically format/minify json in the current buffer
nnoremap <leader>j :%!python -m json.tool<CR>
nnoremap <leader>J :%!json-minify<CR>
" or just the current visual selection
vnoremap <leader>j :!python -m json.tool<CR>
vnoremap <leader>J :!json-minify<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Next and Last (from a gist by sjl)

" Motion for "next/last object".  "Last" here means "previous", not "final".
" Unfortunately the "p" motion was already taken for paragraphs.
"
" Next acts on the next object of the given type in the current line, last acts
" on the previous object of the given type in the current line.
"
" Currently only works for (, [, {, b, r, B, ', and ".
"
" Some examples (C marks cursor positions, V means visually selected):
"
" din'  -> delete in next single quotes                foo = bar('spam')
"                                                      C
"                                                      foo = bar('')
"                                                                C
"
" canb  -> change around next parens                   foo = bar('spam')
"                                                      C
"                                                      foo = bar
"                                                               C
"
" vil"  -> select inside last double quotes            print "hello ", name
"                                                                        C
"                                                      print "hello ", name
"                                                             VVVVVV

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
      let c = "("
  elseif c ==# "B"
      let c = "{"
  elseif c ==# "r"
      let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

