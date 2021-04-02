"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => acid.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:acid_auto_require = 1
let g:acid_alt_paths = ['src/backend']

" nnoremap <leader>r :AcidRequire<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE (asynchronous lint engine)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_fix_on_save = 1
let g:ale_linters = {'clojure': [], 'sh': []}
" I've read that goimports is basically just like gofmt, plus it organizes your
" imports and removes ones you aren't using. So, I prefer goimports over gofmt.
let g:ale_fixers = {'go': ['goimports']}


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
" => asciidoctor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:asciidoctor_fenced_languages = ['python', 'clojure']

" Function to create buffer local mappings
fun! AsciidoctorMappings()
  nnoremap <buffer> <localleader>oo :AsciidoctorOpenRAW<CR>
  nnoremap <buffer> <localleader>op :AsciidoctorOpenPDF<CR>
  nnoremap <buffer> <localleader>oh :AsciidoctorOpenHTML<CR>
  nnoremap <buffer> <localleader>ox :AsciidoctorOpenDOCX<CR>
  nnoremap <buffer> <localleader>ch :Asciidoctor2HTML<CR>
  nnoremap <buffer> <localleader>cp :Asciidoctor2PDF<CR>
  nnoremap <buffer> <localleader>cx :Asciidoctor2DOCX<CR>

  nnoremap <buffer> <localleader>H
        \ :silent! Asciidoctor2HTML<CR>
        \ :silent! AsciidoctorOpenHTML<CR>
  nnoremap <buffer> <localleader>P
        \ :silent! Asciidoctor2PDF<CR>
        \ :silent! AsciidoctorOpenPDF<CR>
  nnoremap <buffer> <localleader>D
        \ :silent! Asciidoctor2DOCX<CR>
        \ :silent! AsciidoctorOpenDOCX<CR>
endfun

" Call AsciidoctorMappings for all `*.adoc` and `*.asciidoc` files
augroup asciidoctor
  autocmd!
  autocmd BufEnter *.adoc,*.asciidoc call AsciidoctorMappings()
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => auto-pairs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup autopairs_config
  " autocmd Filetype clojure let g:AutoPairsFlyMode = 1

  " don't pair single quotes or backticks when editing lisp code
  " autocmd Filetype lisp,scheme,clojure,lfe let b:AutoPairs = {'(':')', '[':']', '{':'}','"':'"'}

  " disable auto-pairs for lisp -- it interferes with parinfer
  autocmd Filetype lisp,scheme,clojure,lfe let b:AutoPairs = {}
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => better-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'ctrlsf']

" function! ReloadWithoutScrolling() abort
"   let l:currentview = winsaveview()
"   edit
"   call winrestview(l:currentview)
" endfunction

function! StripWhitespace() abort
  StripWhitespace
  " try
  "   call ReloadWithoutScrolling()
  " catch
  " endtry
endfunction

nnoremap <silent> <leader><Space> :call StripWhitespace()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => buffergator
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" horizontal bottom (full screen width)
let g:buffergator_viewport_split_policy = "B"
let g:buffergator_split_size = 10
let g:buffergator_suppress_keymaps = 1
nnoremap <space><space> :BuffergatorOpen<CR>

" press ESC to close the buffergator buffer
augroup buffergator_buffer
  autocmd!
  autocmd BufEnter \[\[buffergator-buffers\]\] nnoremap <buffer> <ESC> :bd<CR>
augroup END


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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => coc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HACK to workaround coc not providing a :CocToggle command
function! ToggleCoc() abort
  if len(coc#status()) == 0
    execute 'CocEnable'
  else
    execute 'CocDisable'
  endif
endfunction

nnoremap <silent> <leader>cc :call ToggleCoc()<CR>
nnoremap <leader>cd :CocList diagnostics<CR>
nnoremap <leader>ci :CocInfo<CR>

" press q to close e.g. the :CocInfo buffer
augroup coc_buffers
  autocmd!
  autocmd BufEnter output:///info nnoremap <buffer> q :bd<CR>
augroup END

" don't give |ins-completion-menu| messages
set shortmess+=c
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" A variation on the above that plays nicely with vim-endwise.
" source: https://github.com/roxma/nvim-completion-manager/issues/49#issuecomment-285923119
" (the link above is about ncm2, but the same concept applies to coc)
let g:endwise_no_mappings = 1
imap <C-X><CR>   <CR><Plug>AlwaysEnd
imap <expr> <CR> (pumvisible() ? "\<C-Y>\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd")

nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:coc_enable_locationlist = 0
augroup coc_locationlist
  autocmd!
  autocmd User CocLocationsChange CocList --normal location
augroup END

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

nmap <silent> [k :CocPrev<cr>
nmap <silent> ]k :CocNext<cr>
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation() abort
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! Expand(exp) abort
    let l:result = expand(a:exp)
    return l:result ==# '' ? '' : "file://" . l:result
endfunction

" Highlight symbol under cursor on CursorHold
augroup coc_highlight_symbol_under_cursor
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END
vmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)

nnoremap <silent> crcc :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'cycle-coll', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crth :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crtt :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crtf :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crtl :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cruw :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-thread', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crua :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crml :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
nnoremap <silent> cril :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'introduce-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
nnoremap <silent> crel :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'expand-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cram :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cref :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Function name: ')]})<CR>

" NB: I don't know what codeActions are, and <leader>a conflicts with my
" ZoomToggle binding, so I'm just commenting this out for now.
"
" If/when I learn what codeActions are and want to use them, I'll have to come
" up with a different binding.

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" vmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

augroup coc_load_clojure_content
  autocmd BufReadCmd,FileReadCmd,SourceCmd jar:file://*
        \ call s:LoadClojureContent(expand("<amatch>"))
augroup END

function! s:LoadClojureContent(uri) abort
  setfiletype clojure
  let content = CocRequest('clojure-lsp', 'clojure/dependencyContents', {'uri': a:uri})
  call setline(1, split(content, "\n"))
  setl nomodified
  setl readonly
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => colorizer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:colorizer_auto_color = 1
" Clojure is included because Conjure's log buffer is a Clojure buffer, and
" sometimes I want to use a Clojure REPL to print things that include ANSI
" escape codes for pretty colors.
let g:colorizer_auto_filetype='scss,css,clojure'

" Disable Colorizer's strange default behavior where it de-colorizes whenever
" you leave the buffer.
let g:colorizer_disable_bufleave = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => commentary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup commentary_config
  autocmd!
  autocmd FileType cs,kotlin,adoc setlocal commentstring=//\ %s
  autocmd FileType lisp,clojure,racket setlocal commentstring=;;\ %s
  autocmd FileType sml,ocaml setlocal commentstring=(*\ %s\ *)
  autocmd FileType resolv,crontab setlocal commentstring=#\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => conjure
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: I'd like to have a good setup where ANSI escape codes are interpreted in
" the Conjure log buffer. Currently, neither Colorizer nor Olical's fork of
" AnsiEsc are doing this as well as I'd like. I think Olical/AnsiEsc is more
" likely to get there with time (Colorizer seems to be under-maintained), but
" for now, Colorizer is marginally better, so I'm sticking with Colorizer for
" now. I'm leaving AnsiEsc config intact below, ready to be un-commented when I
" inevitably switch back over to Olical/AnsiEsc.

" Disable the default ANSI escape code stripping so that I can use a separate
" plugin to interpret them and display the colors.
" let g:conjure#log#strip_ansi_escape_sequences_line_limit = 0

let g:conjure#log#hud#passive_close_delay = 1000

let g:conjure#highlight#enabled = v:true

let g:conjure#filetype#sicp = "conjure.client.racket.stdio"

function! ToggleConjureLog() abort
  if expand('%:t') =~ ".*conjure-log-.*"
    execute 'Bclose'
  else
    " Ideally I could call some function provided by Conjure directly to do
    " this, but I wasn't able to figure out how to do that. This mapping will
    " need to be adjusted if I ever configure Conjure to use a different mapping
    " to open the log in a tab, or if Conjure ever changes the default mapping.
    " I think those two things are both pretty unlikely to happen, so meh.
    "
    " Another thing worth noting: normal apparently doesn't work with <leader>
    " and <localleader>, so you have to do some hackery like what's going on
    " here (https://vi.stackexchange.com/a/7780/25687) or just give up and type
    " your actual (local)leader key in the mapping. I'm doing the second one.
    normal \lt
  endif
endfunction

augroup additional_conjure_bindings
  autocmd!

  autocmd FileType clojure,fennel,janet,racket
        \ nnoremap <buffer>
        \ <localleader>cc :call ToggleConjureLog()<CR>
  autocmd FileType clojure,fennel,janet,racket
        \ nnoremap <buffer>
        \ <localleader>cl :call ToggleConjureLog()<CR>

  " mnemonic: eval prompt
  " (like how <localleader>ee is eval expression)
  autocmd FileType clojure,fennel,janet,racket
        \ nnoremap <buffer>
        \ <localleader>ep :ConjureEval<space>

  " press q to close the log buffer
  autocmd BufEnter conjure-log-* nnoremap <buffer> q :Bclose<CR>

  " Automatically enable AnsiEsc (interpret ANSI escape codes) for the Conjure
  " log buffer.
  " autocmd BufEnter conjure-log-* AnsiEsc
augroup END


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
let g:ctrlsf_auto_focus = {"at": "start"}
let g:ctrlsf_winsize = '100%'
" Ignore ctags files. I have this in my global gitignore, which rg respects
" when you run rg at the command-line, but for some reason, it isn't respected
" when using rg via ctrlsf. Weird.
"
" As a workaround, this rg option has the same desired effect.
let g:ctrlsf_extra_backend_args = {'rg': '--glob !tags'}
nmap <leader>f <Plug>CtrlSFPrompt
vmap <leader>f <Plug>CtrlSFVwordExec
nmap <leader>F :CtrlSFOpen<CR>:CtrlSFUpdate<CR>
nmap <leader>td :CtrlSF -R TODO<bar>FIXME<CR>
nmap <leader>8 :CtrlSF -R '.{81,}'<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ctrlspace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

" <ctrl><space> doesn't seem to be sent to Vim, for some reason.
" nnoremap <space><space> :CtrlSpace<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => defx
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" defx somewhat annoyingly doesn't provide any default mappings. I copy-pasted
" this example config from :help defx and modified it.
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
        \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
  call defx#custom#option('_', {
        \ 'columns': 'mark:indent:icon:filename:type:size:time',
        \ })
	call defx#custom#column('time', {
	      \ 'format': '%Y-%m-%d %I:%M %p',
	      \ })
endfunction

function! s:open_defx_if_directory() abort
  " This throws an error if the buffer name contains unusual characters like
  " [[buffergator]]. Desired behavior in those scenarios is to consider the
  " buffer not to be a directory.
  try
    let l:full_path = expand(expand('%:p'))
  catch
    return
  endtry

  " If the path is a directory, delete the (useless) buffer and open defx for
  " that directory instead.
  if isdirectory(l:full_path)
    execute "Defx `expand('%:p')` | bd " . expand('%:r')
  endif
endfunction

augroup defx_config
  autocmd!
  autocmd FileType defx call s:defx_my_settings()

  " It seems like BufReadPost should work for this, but for some reason, I can't
  " get it to fire. BufEnter seems to be more reliable.
  autocmd BufEnter * call s:open_defx_if_directory()
augroup END

" netrw apparently has a similar callback, because sometimes netrw opens instead
" of defx! According to https://stackoverflow.com/a/21687112/2338327, this
" disables netrw.
let loaded_netrwPlugin = 1

nnoremap <silent> -
      \ :Defx `expand('%:p:h')`
      \ -search=`expand('%:p')`<CR>


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
" => dispatch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:dispatch_no_maps = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => elm-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:elm_format_autosave = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fireplace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nnoremap <leader>r :Require!<CR>
" nnoremap <leader>t :RunTests<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-f> :FZF<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <C-g> :GFiles<CR>

" I think I can't use <C-m> for this one because <C-m> is sort of the same thing
" as Enter, so when I press Enter, :Maps<CR> is happening.
nnoremap <leader>m :Maps<CR>

" I can't use <C-h> because I use that to navigate between vim/tmux panes.
nnoremap <leader>h :Helptags<CR>

" I can't use <C-b> for this one because <C-b> is my tmux prefix key.
"
" Using <leader>bb instead of <leader>b because I have other buffer-related
" mappings that start with <leader>b, e.g. <leader>bd to delete the current
" buffer.
nnoremap <leader>bl :Buffers<CR>

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

" source: https://www.reddit.com/r/neovim/comments/djmehv/im_probably_really_late_to_the_party_but_fzf_in_a/f463fxr/
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF() abort
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(15)
  let width = float2nr(80)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gina
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gina#action#index#discard_directories = 1

nnoremap <leader>g<space> :Gina<space>
nnoremap <leader>gA :Gina add --all<CR>:Gina status<CR>
" this one actually comes from fugitive because I like its output better than
" :Gina blame. Putting it here so that I don't have to look in two places for
" all my git-related keybindings.
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gc :Gina commit -v<CR>gg0i
nnoremap <leader>gd :Gina diff<CR>
nnoremap <leader>gD :Gina diff -w<CR>
nnoremap <leader>gg :Gina grep<space>
nnoremap <leader>gi :Gina init<CR>
nnoremap <leader>gl :Gina log --graph --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]" --decorate --all --date=short<CR><CR>
nnoremap <leader>gp :Gina push<CR>
nnoremap <leader>gs :Gina status<CR>
nnoremap <leader>gS :Gina show<CR>

" press q to close gina buffers
augroup gina_buffers
  autocmd!
  autocmd BufEnter gina://* nnoremap <buffer> q :bd<CR>
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_map_keys = 0

" Update gitgutter on BufEnter instead of on FocusGained. Another approach would
" be to get vim/tmux focus events working, however I've observed issues with
" gitgutter not updating even while I'm staying inside Vim, e.g. after making a
" commit via `:Gina commit`, so reacting to BufEnter seems like a better way to
" get this working the way I want it to work.
"
" ref: https://github.com/airblade/vim-gitgutter#when-signs-dont-update-after-focusing-vim
let g:gitgutter_terminal_reports_focus=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitv
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nnoremap <leader>gv :Gitv<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" autocmd FileType go nnoremap <buffer> <leader>r  :GoRun<CR>
" autocmd FileType go nnoremap <buffer> <leader>b  :GoBuild<CR>
" autocmd FileType go nnoremap <buffer> <leader>t  :GoTest<CR>
" autocmd FileType go nnoremap <buffer> <leader>c  :GoCoverage<CR>
" autocmd FileType go nnoremap <buffer> <leader>gd :GoDoc<CR>
" autocmd FileType go nnoremap <buffer> <leader>gb :GoDocBrowser<CR>
" autocmd FileType go nnoremap <buffer> <leader>s  :GoImplements<CR>
" autocmd FileType go nnoremap <buffer> <leader>i  :GoInfo<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gofmt
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I've read that goimports is basically just like gofmt, plus it organizes your
" imports and removes ones you aren't using. So, I prefer goimports over gofmt.
let g:gofmt_exe = 'goimports'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => goyo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gv
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>gv :GV<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => hexokinase
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Hexokinase_highlighters = ['backgroundfull']

let g:Hexokinase_optInPatterns = [
      \ 'full_hex',
      \ 'triple_hex',
      \ 'rgb',
      \ 'rgba',
      \ 'hsl',
      \ 'hsla',
      \ 'colour_names'
      \ ]

let g:Hexokinase_refreshEvents = [
      \ 'BufWrite',
      \ 'BufRead',
      \ 'CursorHoldI',
      \ 'InsertLeave',
      \ 'TextChanged',
      \ ]


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => highlightedyank
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:highlightedyank_highlight_duration = 250


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
" nnoremap <leader>L :Lein<CR>
" nnoremap <leader>B :Boot<CR>
" nnoremap <leader>C :Clj<CR>

" Not really part of jack-in, but it's as if it were
" nnoremap <leader>I :Start! iced repl<CR>


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
  \              [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ]
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
  \     'cocstatus': 'coc#status',
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


"""""""""""""""""""""""""""""""
" => Merlin (OCAML)
"""""""""""""""""""""""""""""""
if executable('opam')
  let g:opamshare = substitute(system('opam config var share 2>/dev/null'),'\n$','','''')
  execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ncm2 (fka nvim-completion-manager)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable ncm2 for all buffers
" autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANTE: :help Ncm2PopupOpen for more information
" set completeopt=noinsert,menuone,noselect

" enter inserts newline when completion window is open
" inoremap <expr> <CR> pumvisible() ? "\<c-y>\<cr>" : "\<CR>"

" A variation on the above that plays nicely with vim-endwise.
" source: https://github.com/roxma/nvim-completion-manager/issues/49#issuecomment-285923119
" let g:endwise_no_mappings = 1
" imap <C-X><CR>   <CR><Plug>AlwaysEnd
" imap <expr> <CR> (pumvisible() ? "\<C-Y>\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd")

" tab completion
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" from :help Ncm2PopupOpen
" autocmd User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
" autocmd User Ncm2PopupClose set completeopt=menuone

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
" => open-browser
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" the gx mapping provided by netrw used to open the URL under the cursor in my
" browser, then it mysteriously stopped working. The new behavior is that it
" curls the URL into a tempfile and then open the file in my browser, and I
" would see the HTML.
"
" I found a tip here (https://vi.stackexchange.com/a/14526) to use this plugin
" instead. I tried it and it works as expected.

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => paredit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:paredit_leader = '\'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open the vim-plug window full-screen
let g:plug_window = 'enew'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => quick-scope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => rainbow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1
let g:rainbow_conf = {'separately': {'html': 0}} " disable for html


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => sandwich
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

" Add recipes for vim-surround-style buns with an extra space.
let g:sandwich#recipes +=
      \ [
      \   {
      \     'buns':         ['{ ', ' }'],
      \     'nesting':      1,
      \     'match_syntax': 1,
      \     'kind':         ['add', 'replace'],
      \     'action':       ['add'],
      \     'input':        ['{']
      \   },
      \
      \   {
      \     'buns':         ['[ ', ' ]'],
      \     'nesting':      1,
      \     'match_syntax': 1,
      \     'kind':         ['add', 'replace'],
      \     'action':       ['add'],
      \     'input':        ['[']
      \   },
      \
      \   {
      \     'buns':         ['( ', ' )'],
      \     'nesting':      1,
      \     'match_syntax': 1,
      \     'kind':         ['add', 'replace'],
      \     'action':       ['add'],
      \     'input':        ['(']
      \   },
      \
      \   {
      \     'buns':         ['{\s*', '\s*}'],
      \     'nesting':      1,
      \     'regex':        1,
      \     'match_syntax': 1,
      \     'kind':         ['delete', 'replace', 'textobj'],
      \     'action':       ['delete'],
      \     'input':        ['{']
      \   },
      \
      \   {
      \     'buns':         ['\[\s*', '\s*\]'],
      \     'nesting':      1,
      \     'regex':        1,
      \     'match_syntax': 1,
      \     'kind':         ['delete', 'replace', 'textobj'],
      \     'action':       ['delete'],
      \     'input':        ['[']
      \   },
      \
      \   {
      \     'buns':         ['(\s*', '\s*)'],
      \     'nesting':      1,
      \     'regex':        1,
      \     'match_syntax': 1,
      \     'kind':         ['delete', 'replace', 'textobj'],
      \     'action':       ['delete'],
      \     'input':        ['(']
      \   },
      \ ]

" Make it so that when I visually select a line and add parens, brackets or
" curly braces, it indents the line that I'm wrapping.
"
" source: https://github.com/machakann/vim-sandwich/tree/a0cde9cfb20d9aff10a09b7fc776231f7856abef#linewise-and-blockwise-operations
let s:command = "'[+1,']-1normal! >>"
let g:sandwich#recipes +=
      \ [
      \   {
      \     'buns':       ['{', '}'],
      \     'motionwise': ['line'],
      \     'kind':       ['add'],
      \     'linewise':   1,
      \     'command':    [s:command]
      \   },
      \
      \   {
      \     'buns':       ['[', ']'],
      \     'motionwise': ['line'],
      \     'kind':       ['add'],
      \     'linewise':   1,
      \     'command':    [s:command]
      \   },
      \   {
      \     'buns':       ['(', ')'],
      \     'motionwise': ['line'],
      \     'kind':       ['add'],
      \     'linewise':   1,
      \     'command':    [s:command]
      \   },
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => sexp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:sexp_enable_insert_mode_mappings = 0

" jump to the end of a sexp and be in insert mode
nnoremap <Bslash>a f)i


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
" nnoremap <leader>T :TagbarToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => unicode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ga :UnicodeName<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimagit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:magit_show_help = 0
let g:magit_toggle_help_mapping = '?'
let g:magit_discard_untracked_do_delete=1
let g:magit_show_magit_mapping='<leader>G'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimfiler
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:vimfiler_as_default_explorer = 1
" let g:vimfiler_time_format = "%b %d %Y %H:%M"

" call vimfiler#custom#profile('default', 'context', {
"       \   'safe': 0,
"       \   'force_quit': 1
"       \ })


""""""""""""""""""""""""""""""
" => vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


""""""""""""""""""""""""""""""
" => vim-tmux-navigator
""""""""""""""""""""""""""""""
" I keep wanting to navigate between vim panes while I'm in insert mode without
" switching back to normal mode first. These mappings let me do that.
"
" The only one that doesn't really work is <C-h>, which can't seem to shed its
" standard behavior of acting like Backspace. It's weird that I can't seem to
" override that, but oh well. I usually keep my vim on the left anyway, so it's
" rare that I'll need it.
"
" Update: I don't actually want to remap <C-k> because that's the stock mapping
" for digraphs and I don't want to retrain my fingers to learn a new mapping for
" that.
imap <C-h> <Esc><C-h>
imap <C-j> <Esc><C-j>
" imap <C-k> <Esc><C-k>
imap <C-l> <Esc><C-l>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prompt for a command to be run in a 20% lower tmux split, without losing
" focus on vim :)
nnoremap <leader>vp :VimuxPromptCommand<CR>
nnoremap <leader>v<space> :VimuxPromptCommand<CR>

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
function! VimuxOperator(type, ...) abort
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

function! VimuxSendBuffer(...) abort
  let pos = winsaveview()
  let arg = exists('a:1') ? ", 0" : ""
  execute "normal! gg0vG$:\<c-u>call VimuxOperator(visualmode()".arg.")\<cr>"
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

function! CreateSkeletonDiaryEntry() abort
  if line('$') == 1 && getline(1) == ''
    read !cat ~/Sync/vimwiki/diary/template.wiki
    " The previous command pastes starting on the line _below_ the cursor (i.e.
    " line 2), so we have to delete the empty line at the top (line 1).
    execute "normal! ggdd"
    " Insert today's date
    execute "%s/DATE-GOES-HERE/" . strftime('%Y-%m-%d (%A)') . "/"
  endif
endfunction

augroup CustomVimwikiMappings
  autocmd!
  " Use my own mappings for increment/decrement header level, ( and ) instead of
  " - and =. This is because I have my own - mapping that I use to open the
  "   current directory in defx.
  autocmd FileType vimwiki nmap ( <Plug>VimwikiRemoveHeaderLevel
  autocmd FileType vimwiki nmap ) <Plug>VimwikiAddHeaderLevel

  " This adds some functionality that vimwiki is missing: if there is no diary
  " entry for today yet, it creates a skeleton from a template.
  autocmd BufEnter *vimwiki/diary/*.wiki call CreateSkeletonDiaryEntry()
augroup end

" I don't use the diary.wiki diary index page. I prefer to use defx to browse
" the directory of diary entries. So, I'm remapping the keybinding that would
" otherwise open the diary index page. vimwiki is nice enough not to overwrite
" this when it loads.
nnoremap <leader>wi :e ~/Sync/vimwiki/diary/<CR>

" ,w,w feels a bit awkward. I like ,wt (mnemonic: "wiki today") better.  Vimwiki
" has its own ,wt mapping, but I never use it (it opens the wiki index page in a
" tab, and I don't really use tabs).
nmap <leader>wt <Plug>VimwikiMakeDiaryNote


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vista
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 0
let g:vista_sidebar_width = 40
" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
let g:vista_icon_indent = ["▸ ", ""]
nnoremap <leader>T :Vista!!<CR>

" Don't blink the cursor after jumping to definition.
let g:vista_top_level_blink = [0, 0]

" Jump to the definition the cursor is over for easy previewing.
let g:vista_echo_cursor_strategy = 'scroll'

" Close the Vista window once I choose something.
let g:vista_close_on_jump = 1

" Instead of the nested structure used by default, list all tags by kind, e.g.
" all methods, then all namespaces, etc. This display looks cleaner to me.
let g:vista#renderer#ctags = 'kind'


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
" => which-key
""""""""""""""""""""""""""""""
nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '\'<CR>
nnoremap <silent> <Space>       :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '\'<CR>
vnoremap <silent> <Space>       :<c-u>WhichKeyVisual '<Space>'<CR>

" TODO: Add description dictionaries so that it's easier to see what each key
" mapping does. The default display is the command that's run, but that
" isn't very readable.
"
" See: https://github.com/liuchengxu/vim-which-key#configuration
"
" WIP:
call which_key#register(',', "g:which_key_map_leader")
call which_key#register('\', "g:which_key_map_localleader")
call which_key#register('<Space>', "g:which_key_map_space")
let g:which_key_map_leader = {}
let g:which_key_map_localleader = {}
let g:which_key_map_space = {}

let g:which_key_map_leader.b = {
      \ 'name': '+buffers',
      \ 'd': 'delete this buffer',
      \ 'D': 'delete all buffers',
      \ 'l': 'list buffers',
      \ 'o': 'delete all other buffers'
      \ }

let g:which_key_map_leader.c = {
      \ 'name': '+coc',
      \ 'c': 'toggle coc',
      \ 'd': 'coc diagnostics',
      \ 'f': 'coc: format selected',
      \ 'i': 'coc info'
      \ }

let g:which_key_map_leader.e = {
      \ 'name': '+edit',
      \ 'c': 'config directory',
      \ 'm': 'edit mappings',
      \ 'p': 'edit plugins',
      \ 'P': 'edit plugins config',
      \ 'v': 'edit vimrc',
      \ }

" NB: This doesn't work:
"     \ '<Space>': 'enter git command',
"
" It seems like a special case that the author of vim-which-key didn't foresee.
"
" For now, I'm happy with leaving it out of the map and letting it display as:
"
"     SPC → Gina<space>
let g:which_key_map_leader.g = {
      \ 'name': '+git',
      \ 'A': 'git add --all',
      \ 'b': 'git blame',
      \ 'c': 'git commit',
      \ 'd': 'git diff',
      \ 'D': 'git diff (ignore whitespace)',
      \ 'g': 'git grep',
      \ 'i': 'git init',
      \ 'l': 'git log',
      \ 'p': 'git push',
      \ 's': 'git status',
      \ 'S': 'git show',
      \ 'v': 'browse git commits',
      \ }

" vim-HiLinkTrace provides this mapping whether you like it or not. It sort of
" goes against the hierarchical organization of mappings suggested by which-key.
" I'm tempted to remove vim-HiLinkTrace because I almost never use it, but on
" the other hand, I don't currently have a use for 'h' as a mapping prefix key,
" so I'm OK with this.
let g:which_key_map_leader.h = {
      \ 'name': '+hilinks',
      \ 'l': {
      \   'name': '+hilinks',
      \   't': 'trace highlighting',
      \   },
      \ }

let g:which_key_map_leader.j = {
      \ 'name': '+json',
      \ 'f': 'format JSON',
      \ 'm': 'minify JSON',
      \ }

let g:which_key_map_leader.s = {
      \ 'name': '+source',
      \ 'v': 'source vimrc',
      \ }

let g:which_key_map_leader.B = {
      \ 'name': '+bash',
      \ 'i': 'initialize Bash script'
      \ }

""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim_runtime/temp_dirs/'
endif
