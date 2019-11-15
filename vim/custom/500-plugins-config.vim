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
let g:ale_linters = {'clojure': []}
let g:ale_fixers = {'go': ['gofmt', 'goimports']}


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
  au!
  au BufEnter *.adoc,*.asciidoc call AsciidoctorMappings()
augroup END


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

function! ReloadWithoutScrolling()
  let l:currentview = winsaveview()
  edit
  call winrestview(l:currentview)
endfunction

function! StripWhitespaceAndReloadBuffer()
  StripWhitespace
  try
    call ReloadWithoutScrolling()
  catch
  endtry
endfunction

" I originally added this mapping to easily strip whitespace, then eventually I
" found myself wanting to extend it to do things like update gitgutter signs,
" things that only happen when you do :e. So I've added :e to this mapping.
nnoremap <silent> <leader><Space> :call StripWhitespaceAndReloadBuffer()<CR>


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
function! ToggleCoc()
  if len(coc#status()) == 0
    execute 'CocEnable'
  else
    execute 'CocDisable'
  endif
endfunction

nnoremap <silent> <leader>cc :call ToggleCoc()<CR>
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
autocmd User CocLocationsChange CocList --normal location

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

function! s:show_documentation()
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
autocmd CursorHold * silent call CocActionAsync('highlight')
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

autocmd BufReadCmd,FileReadCmd,SourceCmd jar:file://* call s:LoadClojureContent(expand("<amatch>"))
 function! s:LoadClojureContent(uri)
  setfiletype clojure
  let content = CocRequest('clojure-lsp', 'clojure/dependencyContents', {'uri': a:uri})
  call setline(1, split(content, "\n"))
  setl nomodified
  setl readonly
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => colorizer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I was hoping that this would enable colorizer for every filetype, but I still
" had to run :ColorHighlight (or :ColorToggle) manually even after adding this.
let g:colorizer_auto_color = 1

" Adding this did the trick. It's not ideal, because there are probably other
" filetypes where I would want colorizer to do its thing, but I can always add
" those as I find them.
"
" Clojure is included here because colorizer interprets ANSI escape codes, and I
" use Conjure, which has a log buffer whose filetype is Clojure. Conjure +
" colorizer = awesome colored text output on stdout/stderr!
let g:colorizer_auto_filetype='scss,css,clojure'

" Hackery to work around colorizer's auto-colorizer behavior being flaky.
"
" It's still not 100% working the way I want it to... the Conjure log buffer
" needs to be in focus in order for its content to be colorized. When I leave
" and go into another split, the existing content is colorized, but new content
" is not. (Actually, strangely, new content has ANSI codes stripped out, but it
" isn't rendered in color, it's just the normal text color.)
"
" I've filed an issue: https://github.com/chrisbra/Colorizer/issues/77
augroup colorize_conjure
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter,BufLeave /tmp/conjure.cljc ColorHighlight
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => commentary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType cs,kotlin setlocal commentstring=//\ %s
autocmd FileType lisp,clojure,racket setlocal commentstring=;;\ %s
autocmd FileType sml,ocaml setlocal commentstring=(*\ %s\ *)
autocmd FileType resolv,crontab setlocal commentstring=#\ %s
autocmd FileType sql setlocal commentstring=--\ %s


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => conjure
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:conjure_fold_multiline_results = 0
let g:conjure_log_blacklist = ["up", "eval", "ret", "load-file"]
let g:conjure_log_direction = "horizontal"
let g:conjure_log_size_large = 100
let g:conjure_quick_doc_normal_mode = 0

augroup additional_conjure_bindings
  autocmd!

  " this is easier to type than <localleader>cL
  autocmd FileType clojure
        \ nnoremap <buffer>
        \ <localleader>cc :ConjureToggleLog<CR>

  " mnemonic: eval prompt
  " (like how <localleader>ee is eval expression)
  autocmd FileType clojure
        \ nnoremap <buffer>
        \ <localleader>ep :ConjureEval<space>

  " press q to close the log buffer
  autocmd BufEnter /tmp/conjure.cljc nnoremap <buffer> q :ConjureCloseLog<CR>
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
nmap <leader>f <Plug>CtrlSFPrompt
vmap <leader>f <Plug>CtrlSFVwordExec
nmap <leader>F :CtrlSFOpen<CR>:CtrlSFUpdate<CR>
nmap <leader>td :CtrlSF -R TODO<bar>FIXME<CR>
nmap <leader>8 :CtrlSF -R '.{81,}'<CR>
let g:ctrlsf_auto_focus = {"at": "start"}
let g:ctrlsf_winsize = '100%'


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
" this example config from :help defx.
autocmd FileType defx call s:defx_my_settings()
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

" I think I can't use <C-m> for this one because <C-m> is sort of the same thing
" as Enter, so when I press Enter, :Maps<CR> is happening.
nnoremap <leader>m :Maps<CR>

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

function! FloatingFZF()
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
nnoremap <leader>g<space> :Gina<space>
nnoremap <leader>gA :Gina add --all<CR>:Gina status<CR>
" this one actually comes from fugitive because I like its output better than
" :Gina blame. Putting it here so that I don't have to look in two places for
" all my git-related keybindings.
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gina commit -v<CR>:let @a=system("git-commit-message-prefix")<CR>ggi<C-r>a
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
" au FileType go nnoremap <buffer> <leader>r  :GoRun<CR>
" au FileType go nnoremap <buffer> <leader>b  :GoBuild<CR>
" au FileType go nnoremap <buffer> <leader>t  :GoTest<CR>
" au FileType go nnoremap <buffer> <leader>c  :GoCoverage<CR>
" au FileType go nnoremap <buffer> <leader>gd :GoDoc<CR>
" au FileType go nnoremap <buffer> <leader>gb :GoDocBrowser<CR>
" au FileType go nnoremap <buffer> <leader>s  :GoImplements<CR>
" au FileType go nnoremap <buffer> <leader>i  :GoInfo<CR>


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
" au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
" au User Ncm2PopupClose set completeopt=menuone

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
" Disable insert mode <CR> and <Tab> mappings that interfere with autocomplete.
let g:vimwiki_table_mappings = 0



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
" => YankRing
""""""""""""""""""""""""""""""
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim_runtime/temp_dirs/'
endif