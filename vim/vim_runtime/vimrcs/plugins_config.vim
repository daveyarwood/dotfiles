"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => acid.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:acid_auto_require=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => better-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'ctrlsf']

nnoremap <leader><Space> :StripWhitespace<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => clojure-static
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify<Plug>PeepOpenroxy,extend-type,extend-protocol,letfn'
let g:clojure_align_multiline_strings = 1
let g:clojure_maxlines = 0


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

" VirtualBox doesn't send Ctrl-Space to my Linux VM for some reason;
nnoremap <space><space> :CtrlSpace<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => deoplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:deoplete#enable_at_startup = 1

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

" Use TAB and SHIFT-TAB to cycle through completions
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" Close the popup window when I accept a completion
autocmd CompleteDone * pclose!

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
" => paredit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:paredit_leader = '\'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => rainbow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1
let g:rainbow_conf = {'separately': {'html': 0}} " disable for html


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
" => tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>T :TagbarToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => unicode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ga :UnicodeName<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-commentary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType cs setlocal commentstring=//\ %s


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


