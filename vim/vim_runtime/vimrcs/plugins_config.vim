"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => acid.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:acid_auto_require = 1
let g:acid_alt_paths = ['src/backend']

nnoremap <leader>r :AcidRequire<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE (asynchronous lint engine)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_completion_enabled = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:airline_theme = 'luna'                         " airline colorscheme
" let g:airline_powerline_fonts = 1                    " Fancy symbols
" let g:airline#extensions#tabline#enabled = 1         " Enable the list of buffers
" let g:airline#extensions#tabline#fnamemod = ':t'     " Show just the filename
" let g:airline#extensions#tabline#tab_nr_type = 1     " Show buffer #, not # of splits
" let g:airline#extensions#tabline#show_tab_nr = 1     " Show buffer # in tabline
" let g:airline#extensions#tabline#show_tab_type = 1   " Show the tab type
" let g:airline#extensions#tabline#buffer_idx_mode = 1 " Show buffer index
" let g:airline#extensions#hunks#enabled = 0 " don't show +N ~N -N for changed hunks
" let g:airline_section_z = airline#section#create(['%3p%% ', 'linenr', ':%3v'])

" nmap <leader>1 <Plug>AirlineSelectTab1
" nmap <leader>2 <Plug>AirlineSelectTab2
" nmap <leader>3 <Plug>AirlineSelectTab3
" nmap <leader>4 <Plug>AirlineSelectTab4
" nmap <leader>5 <Plug>AirlineSelectTab5
" nmap <leader>6 <Plug>AirlineSelectTab6
" nmap <leader>7 <Plug>AirlineSelectTab7
" nmap <leader>8 <Plug>AirlineSelectTab8
" nmap <leader>9 <Plug>AirlineSelectTab9


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => auto-pairs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" au Filetype clojure let g:AutoPairsFlyMode = 1

" don't pair single quotes or backticks when editing lisp code
" au Filetype lisp,scheme,clojure,lfe let b:AutoPairs = {'(':')', '[':']', '{':'}','"':'"'}

" disable auto-pairs for lisp -- it interferes with parinfer
au Filetype lisp,scheme,clojure,lfe let b:AutoPairs = {}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => better-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'ctrlsf']

nnoremap <leader><Space> :StripWhitespace<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => calendar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:calendar_google_calendar = 1
let g:calendar_clock_12hour = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => clj-refactor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clj_refactor_prefix_rewriting = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => clojure-static
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '-tpl$']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn'
let g:clojure_align_multiline_strings = 1
let g:clojure_maxlines = 0


""""""""""""""""""""""""""""""
" => ctrlp
""""""""""""""""""""""""""""""
" let g:ctrlp_working_path_mode = 0

" let g:ctrlp_map = '<c-f>'
" " map <leader>j :CtrlP<cr>
" " map <c-b> :CtrlPBuffer<cr>

" let g:ctrlp_max_height = 20
" let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|^.git$\|_site'

" let g:ctrlp_use_caching = 0
" if executable('ag')
"     set grepprg=ag\ --nogroup\ --nocolor

"     let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" else
"   let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
"   let g:ctrlp_prompt_mappings = {
"     \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
"     \ }
" endif


""""""""""""""""""""""""""""""
" => ctrlsf
""""""""""""""""""""""""""""""
nmap <leader>f <Plug>CtrlSFPrompt
vmap <leader>f <Plug>CtrlSFVwordExec
let g:ctrlsf_auto_focus = {"at": "start"}


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
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" Close the popup window when I accept a completion
" autocmd CompleteDone * pclose!

" Enable integration with the OCAML tool Merlin
if !exists('g:deoplete#omni_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.ocaml = '[^. *\t]\.\w*|\s\w*|#'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fireplace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nnoremap <leader>r :Require!<CR>
" nnoremap <leader>t :RunTests<CR>

" vim-fireplace provides a formatexpr that relies on Cider connection. I don't
" like this because sometimes I want to edit Clojure code without being
" connected to Cider or a REPL, and I want to be able to type gq and have my
" code by formatted to 80 columns. I don't really care about the cljfmt features
" provided by vim-fireplace's formatexpr, so let's just turn that off and retain
" the default gq behavior.
"
" Reference:
" https://clojurians-log.clojureverse.org/vim-fireplace/2017-06-07.html
" https://github.com/tpope/vim-fireplace/issues/298#issuecomment-306863402
"
" autocmd FileType clojure nnoremap <buffer> gq gw
autocmd FileType clojure vnoremap <buffer> gq gw
autocmd FileType clojure nnoremap <buffer> gqq gww
"
" UPDATE 2018-04-23: gq is significantly faster than = or gw at formatting large
" clj/cljs files. So, it's valuable to have gq as an option when I'm connected
" to a REPL.
"
" I'm so used to using =, I'm just going to make that use gq.
" autocmd FileType clojure nnoremap <buffer> = gq
" autocmd FileType clojure nnoremap <buffer> == gqq


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-f> :FZF<CR>
nnoremap <C-g> :GFiles<CR>

" I think I need a new keybinding for this one because <C-m> is sort of the same
" thing as Enter, so when I press Enter, :Maps<CR> is happening.
" nnoremap <C-m> :Maps<CR>

" <C-t> is already the stock Vim keybinding for 'go back to where you were after
" following a tag', and it's so ingrained in my muscle memory, I can't remap it
" to something else. So this mapping is a bit of an oddball, but I'm OK with it.
" It actually kind of fits in with the <leader>T mapping for tagbar, another Vim
" plugin also related to tags, so it feels alright.
"
" Another note: I wanted <leader>t but I have other mappings for the neoterm
" plugin that are <leader>t followed by another key. <leader>tt isn't so bad,
" though.
nnoremap <leader>tt :Tags<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gina
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>g<space> :Gina<space>
" this one actually comes from fugitive because I like its output better than
" :Gina blame. Putting it here so that I don't have to look in two places for
" all my git-related keybindings.
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gina commit<CR>
nnoremap <leader>gd :Gina diff<CR>
nnoremap <leader>gg :Gina grep<space>
nnoremap <leader>gi :Gina init<CR>
nnoremap <leader>gl :Gina log --graph --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]" --decorate --all --date=short<CR><CR>
nnoremap <leader>gp :Gina push<CR>
nnoremap <leader>gs :Gina status<CR>
nnoremap <leader>gA :Gina add --all<CR>:Gina status<CR>

" press q to close gina buffers
augroup gina_buffers
  autocmd!
  autocmd BufEnter gina://* nnoremap <buffer> q :bd<CR>
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_map_keys = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitv
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>gv :Gitv<CR>



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
" => iced
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nmap <localleader>'   <Plug>(iced_connect)
" nmap <localleader>ei  <Plug>(iced_eval)<Plug>(sexp_inner_element)``
" nmap <localleader>ee  <Plug>(iced_eval)<Plug>(sexp_outer_list)``
" nmap <localleader>et  <Plug>(iced_eval_outer_top_list)
" " nmap <localleader>er  <Plug>(iced_eval_repl)<Plug>(sexp_outer_top_list)``
" nmap <localleader>er  :<C-u>IcedEval *e<CR>
" nmap <localleader>E   :<C-u>IcedEval<space>
" nmap <localleader>en  <Plug>(iced_eval_ns)
" nmap <localleader>ep  <Plug>(iced_print_last)
" nmap <localleader>eb  <Plug>(iced_require)
" nmap <localleader>eB  <Plug>(iced_require_all)
" nmap <localleader>eu  <Plug>(iced_undef)
" nmap <localleader>eM  <Plug>(iced_macroexpand_outer_list)
" nmap <localleader>em  <Plug>(iced_macroexpand_1_outer_list)
" nmap <localleader>tt  <Plug>(iced_test_under_cursor)
" nmap <localleader>tl  <Plug>(iced_test_rerun_last)
" nmap <localleader>ts  <Plug>(iced_test_spec_check)
" nmap <localleader>to  <Plug>(iced_test_buffer_open)
" nmap <localleader>tn  <Plug>(iced_test_ns)
" nmap <localleader>tp  <Plug>(iced_test_all)
" nmap <localleader>tr  <Plug>(iced_test_redo)
" nmap <localleader>ss  <Plug>(iced_stdout_buffer_open)
" nmap <localleader>sl  <Plug>(iced_stdout_buffer_clear)
" nmap <localleader>sq  <Plug>(iced_stdout_buffer_close)
" nmap <localleader>rcn <Plug>(iced_clean_ns)
" nmap <localleader>ram <Plug>(iced_add_missing)
" nmap <localleader>ran <Plug>(iced_add_ns)
" nmap <localleader>rtf <Plug>(iced_thread_first)
" nmap <localleader>rtl <Plug>(iced_thread_last)
" nmap <localleader>ref <Plug>(iced_extract_function)
" nmap <localleader>rml <Plug>(iced_move_to_let)
" nmap <localleader>hs  <Plug>(iced_source_show)
" nmap <localleader>hg  <Plug>(iced_grimoire_open)
" nmap <localleader>hh  <Plug>(iced_command_palette)
" nmap <localleader>br  <Plug>(iced_related_namespace)
" nmap <localleader>bs  <Plug>(iced_browse_spec)
" nmap <localleader>bt  <Plug>(iced_browse_test_under_cursor)
" nmap <localleader>jn  <Plug>(iced_jump_to_next_sign)
" nmap <localleader>jN  <Plug>(iced_jump_to_prev_sign)
" nmap <localleader>gl  <Plug>(iced_goto_let)
" nmap <localleader>*   <Plug>(iced_iced)
" nmap <localleader>fr  <Plug>(iced_find_var_references)
" nmap <localleader>fR  <Plug>(iced_find_var_references!)
" nmap <localleader>/   :<C-u>IcedGrep<Space>
" " nmap <C-]>       <Plug>(iced_def_jump)
" " nmap <C-t>       <Plug>(iced_def_back)
" nmap K           <Plug>(iced_document_open)
" nmap ==          <Plug>(iced_format)

" press q to close iced buffers
augroup iced_buffers
  autocmd!
  autocmd BufEnter iced_* nnoremap <buffer> q :bd!<CR>
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => jack-in
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>L :Lein<CR>
nnoremap <leader>B :Boot<CR>
nnoremap <leader>C :Clj<CR>

" Not really part of jack-in, but it's as if it were
nnoremap <leader>I :Start! iced repl<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => LanguageClient
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ 'clojure': ['bash', '~/bin/clojure-lsp'],
    \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
  \   'colorscheme': 'onehalfdark',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \     ],
  \     'right': [['lineinfo'],
  \               ['percent'],
  \               ['fileformat', 'fileencoding', 'filetype']]
  \   },
	\   'component': {
	\     'lineinfo': ' %3l:%-2v',
	\   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   }
  \ }
let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': ''
  \}

let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ncm2 (fka nvim-completion-manager)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANTE: :help Ncm2PopupOpen for more information
" set completeopt=noinsert,menuone,noselect

" enter inserts newline when completion window is open
" inoremap <expr> <CR> pumvisible() ? "\<c-y>\<cr>" : "\<CR>"

" A variation on the above that plays nicely with vim-endwise.
" source: https://github.com/roxma/nvim-completion-manager/issues/49#issuecomment-285923119
let g:endwise_no_mappings = 1
imap <C-X><CR>   <CR><Plug>AlwaysEnd
imap <expr> <CR> (pumvisible() ? "\<C-Y>\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd")

" tab completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" from :help Ncm2PopupOpen
au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
au User Ncm2PopupClose set completeopt=menuone

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neomake
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run neomake on insert and normal mode change and upon reading or writing a
" buffer, with a 500ms delay.
" call neomake#configure#automake('nrwi', 500)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neoterm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neoterm_shell = 'fish'
let g:neoterm_autoscroll = 1
let g:neoterm_keep_term_open = 0
let g:neoterm_autoinsert = 1

nmap gt <Plug>(neoterm-repl-send)
xmap gt <Plug>(neoterm-repl-send)
nmap gtt <Plug>(neoterm-repl-send-line)

" nnoremap <silent> <f10> :TREPLSendFile<cr>
" nnoremap <silent> <f9> :TREPLSendLine<cr>
" vnoremap <silent> <f9> :TREPLSendSelection<cr>

" open the default terminal (mnemonic: terminal prompt)
nnoremap <silent> ,tp :above Topen<CR>

" prompt to use the default terminal or terminals 1-3
" Usage: ,t<space>ls<CR>
nnoremap ,t<space> :above T<space>
nnoremap ,t1 :above T1<space>
nnoremap ,t2 :above T2<space>
nnoremap ,t3 :above T3<space>

" hide/close terminal
nnoremap <silent> ,tC :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tc :call neoterm#clear()<cr>
" interrupts the current job (send a <c-c>)
nnoremap <silent> ,ti :call neoterm#kill()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => nim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endfun

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i


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
" => sexp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:sexp_enable_insert_mode_mappings = 0


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

" enable syntastic integration with the OCAML tool Merlin
let g:syntastic_ocaml_checkers = ['merlin']

" enable syntastic integration with swiftpm and swiftlint
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']


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
autocmd FileType cs,kotlin setlocal commentstring=//\ %s
autocmd FileType lisp,clojure,racket setlocal commentstring=;;\ %s
autocmd FileType sml,ocaml setlocal commentstring=(*\ %s\ *)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimagit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:magit_show_help = 0
let g:magit_toggle_help_mapping = '?'
let g:magit_discard_untracked_do_delete=1
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
" Prompt for a command to be run in a 20% lower tmux split, without losing
" focus on vim :)
nnoremap <leader>vp :VimuxPromptCommand<CR>

" Opens a shell in the split.
nnoremap <leader>vo :call VimuxOpenRunner()<CR>

" Re-run the last command.
nnoremap <leader>vv :VimuxRunLastCommand<CR>

" Interrupt whatever process is running in the runner pane.
nnoremap <leader>vi :VimuxInterruptRunner<CR>

" Zoom the runner pane.
nnoremap <leader>vz :VimuxZoomRunner<CR>

" Clear the runner pane. (i.e. Ctrl-L)
nnoremap <leader>vc :call VimuxSendKeys("C-l")<CR>

" Close vimux runner pane.
nnoremap <leader>vC :VimuxCloseRunner<CR>

" An operator for sending text to Vimux.
function! VimuxOperator(type, ...)
  let previous = @n

  " yank target/selected text into "n
  if a:type ==# 'char' || a:type ==# 'line'
    silent! normal `[v`]"ny
  else "visual
    silent! normal gv"ny
  endif

  let input = @n

  " restore whatever was in "n before
  let @n = previous

  if exists('a:1')
    let input = substitute(input, '\n', ' ', 'g')
  endif

  " if input already ends with a newline, don't send an extra newline
  if input =~# '\n$'
    call VimuxRunCommand(input, 0)
  else
    call VimuxRunCommand(input)
  endif

endfunction

nnoremap <leader>vs :set operatorfunc=VimuxOperator<cr>g@
nmap <leader>vss V<leader>vs
vnoremap <leader>vs :<c-u>call VimuxOperator(visualmode())<cr>
vnoremap <leader>vS :<c-u>call VimuxOperator(visualmode(), 0)<cr>

function! VimuxSendBuffer(...)
  let pos = winsaveview()
  let arg = exists('a:1') ? ", 0" : ""
  execute "normal! ggvG$:\<c-u>call VimuxOperator(visualmode()".arg.")\<cr>"
  call winrestview(pos)
endfunction

command! VimuxSendBuffer
  \ call VimuxSendBuffer()

nnoremap <buffer> <leader>vf
  \ :call VimuxSendBuffer()<CR>

nnoremap <buffer> <leader>vF
  \ :call VimuxSendBuffer(0)<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimwiki
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [{'path': '~/Sync/vimwiki', 'path_html': '~/Sync/vimwiki/html'}]



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vlime
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" A handful of vlime mappings conflict with vim-sexp mappings.
" vlime courteously does not overwrite them, so I can redefine the conflicting
" mappings to different keys here.
augroup LocalVlimeKeys
  autocmd!
  " mnemonic: Send File
  autocmd FileType lisp nnoremap <silent> <buffer> <LocalLeader>sf
        \ :call vlime#plugin#LoadFile(expand("%:p"))<cr>
  " mnemonic: Vlime Interactive mode
  autocmd FileType lisp nnoremap <silent> <buffer> <LocalLeader>vi
        \ :call vlime#plugin#InteractionMode()<cr>
augroup end


""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim_runtime/temp_dirs/'
endif


"""""""""""""""""""""""""""""""
" => Merlin (OCAML)
"""""""""""""""""""""""""""""""
if executable('opam')
  let g:opamshare = substitute(system('opam config var share 2>/dev/null'),'\n$','','''')
  execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif
