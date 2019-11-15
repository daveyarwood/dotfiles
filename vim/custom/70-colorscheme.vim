let g:colorscheme_mode = v:null

" source: https://stackoverflow.com/a/235970/2338327
function! s:HighlightOverLength() abort
  highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  match OverLength /\%81v.\+/
endfunction
command! HighlightOverLength call s:HighlightOverLength()
nnoremap <leader>* :HighlightOverLength<CR>

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
  call s:HighlightOverLength()
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
  call s:HighlightOverLength()
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

