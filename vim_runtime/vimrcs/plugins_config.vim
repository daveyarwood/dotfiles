"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme = 'luna'                         " airline colorscheme
let g:airline_powerline_fonts = 1                    " Fancy symbols
" let g:airline#extensions#tabline#enabled = 1         " Enable the list of buffers
" let g:airline#extensions#tabline#fnamemod = ':t'     " Show just the filename
" let g:airline#extensions#tabline#tab_nr_type = 1     " Show buffer #, not # of splits
" let g:airline#extensions#tabline#show_tab_nr = 1     " Show buffer # in tabline
" let g:airline#extensions#tabline#show_tab_type = 1   " Show the tab type
" let g:airline#extensions#tabline#buffer_idx_mode = 1 " Show buffer index
let g:airline#extensions#hunks#enabled = 0 " don't show +N ~N -N for changed hunks
let g:airline_section_z = airline#section#create(['%3p%% ', 'linenr', ':%3v'])

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => better-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'ctrlsf']

nnoremap <leader><Space> :StripWhitespace<CR>


""""""""""""""""""""""""""""""
" => bufExplorer
""""""""""""""""""""""""""""""
" let g:bufExplorerDefaultHelp=0
" let g:bufExplorerShowRelativePath=1
" let g:bufExplorerFindActive=1
" let g:bufExplorerSortBy='name'
" map <leader>o :BufExplorer<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => calendar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => clojure-static
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify<Plug>PeepOpenroxy,extend-type,extend-protocol,letfn'
let g:clojure_align_multiline_strings = 1


""""""""""""""""""""""""""""""
" => ctrlp
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
" map <leader>j :CtrlP<cr>
" map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|^.git$\|_site'

let g:ctrlp_use_caching = 0
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif


""""""""""""""""""""""""""""""
" => ctrlsf
""""""""""""""""""""""""""""""
nmap <leader>f <Plug>CtrlSFPrompt
vmap <leader>f <Plug>CtrlSFVwordExec


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ctrlspace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fireplace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>r :Require!<CR>
nnoremap <leader>t :RunTests<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_map_keys = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
au FileType go nnoremap <buffer> <leader>r  :GoRun<CR>
au FileType go nnoremap <buffer> <leader>b  :GoBuild<CR>
au FileType go nnoremap <buffer> <leader>t  :GoTest<CR>
au FileType go nnoremap <buffer> <leader>c  :GoCoverage<CR>
au FileType go nnoremap <buffer> <leader>gd :GoDoc<CR>
au FileType go nnoremap <buffer> <leader>gb :GoDocBrowser<CR>
au FileType go nnoremap <buffer> <leader>s  :GoImplements<CR>
au FileType go nnoremap <buffer> <leader>i  :GoInfo<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => goyo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lexima
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call lexima#add_rule({'char': '/* ', 'input_after': ' */', 'filetype': 'c'})
call lexima#add_rule({'char': '<BS>', 'at': '/\*\%# ', 'input': '<BS><BS>', 'delete': 3, 'filetype': 'c'})
call lexima#add_rule({'char': '<CR>', 'at': '/\*.*\%#.*\*/', 'input': '<CR><CR><BS><BS><Esc>kA<Space>', 'filetype': 'c'})
" Disable lexima.vim in clojure buffers
autocmd FileType clojure let b:lexima_disabled = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:NERDTreeWinPos = "right"
" let NERDTreeIgnore = ['\.pyc$']
" let g:NERDTreeWinSize=35
" map <leader>nn :NERDTreeToggle<cr>
" map <leader>nb :NERDTreeFromBookmark
" map <leader>nf :NERDTreeFind<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => paredit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:paredit_leader = '\'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => salve
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:salve_auto_start_repl = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => startify
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_python_checkers=['pyflakes']
" fixes lag related to having both vim-go and syntastic installed
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>T :TagbarToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => unicode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ga :UnicodeName<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimagit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:magit_show_help = 0
let g:magit_toggle_help_mapping = '?'
nmap <leader>G :Magit<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimfiler
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_time_format = "%b %d %Y %H:%M"

call vimfiler#custom#profile('default', 'context', {
      \   'safe': 0,
      \   'force_quit': 1
      \ })


""""""""""""""""""""""""""""""
" => vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prompt for a command to be run in a 20% lower tmux split, witohut losing
" focus on vim :)
nnoremap <leader>v :VimuxPromptCommand<CR>

" Close vimux runner window
nnoremap <leader>V :VimuxCloseRunner<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimwiki
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki', 'path_html': '~/Dropbox/vimwiki/html'}]


""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim_runtime/temp_dirs/'
endif


