" terminal color / italics finagling
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" Highlight characters in column 81+ with a red background.
" (source: https://stackoverflow.com/a/235970/2338327)
function! s:HighlightCharactersOver80() abort
  highlight OverLength ctermbg=red ctermfg=white guibg=#592929
        \ | match OverLength /\%81v.\+/
endfunction

" These commands are run whenever the colorscheme is changed. They serve as
" hooks to further customize colors on top of the current colorschem.
"
" Hooks:
" 1. Italicize comments.
" 2. Highlight characters in column 81+ with a red background.
augroup ColorSchemeMods
  autocmd!
  autocmd ColorScheme *
        \ highlight Comment cterm=italic
        \ | call s:HighlightCharactersOver80()
augroup END

let g:colorscheme_mode = v:null

" i use this theme most of the time
function! s:DarkMode() abort
  let g:colorscheme_mode = 'dark'
  let g:gruvbox_italic=1
  set background=dark
  colorscheme gruvbox
  lua require('user.lualine').set_lualine_theme('everforest')

  " 2024-10-27: After updating Neovim recently, my status line  colors were
  " inverted. This appears to have been a deliberate breaking change in Neovim
  " requiring changes in nvim-lualine.
  "
  " The changes have not yet been implemented, but this was offered by another
  " user as a workaround, and it works.
  "
  " See: https://github.com/nvim-lualine/lualine.nvim/issues/1312
  "
  " TODO: Remove this in the future if/when a fix arrives in nvim-lualine.
  lua vim.api.nvim_set_hl(0, "StatusLine", {reverse = false})
  lua vim.api.nvim_set_hl(0, "StatusLineNC", {reverse = false})

  " let ayucolor="dark"
  " colorscheme ayu
endfunction
command! DarkMode call s:DarkMode()

" a decent looking light theme to use when giving demos, etc.
function! s:LightMode() abort
  let g:colorscheme_mode = 'light'
  set background=light

  " 0 = low, 1 = medium, 2 = high visibility; i think medium looks best
  " let g:mayansmoke_cursor_line_visibility = 1
  " colorscheme mayansmoke

  " use a slightly darker background, like GitHub inline code blocks
  " let g:github_colors_soft = 1
  " more blocky diff markers in signcolumn (e.g. GitGutter)
  let g:github_colors_block_diffmark = 1
  colorscheme github
  lua require('user.lualine').set_lualine_theme('ayu_light')
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
