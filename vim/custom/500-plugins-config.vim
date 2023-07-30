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
" => baleia
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reference: https://github.com/m00qek/baleia.nvim#with-conjure
let s:baleia = luaeval("require('baleia').setup { line_starts_at = 3 }")
let g:conjure#log#strip_ansi_escape_sequences_line_limit = 0
autocmd BufWinEnter conjure-log-* call s:baleia.automatically(bufnr('%'))


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
" => clojure-static
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '-tpl$']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn'
let g:clojure_align_multiline_strings = 1
" In 2017, I added this setting for some reason. It overrides the default, which
" is to only parse 300 lines for smart indentation, etc. 0 means unbounded. It
" will parse the entire file. Which works fine for small files, but it reeeeally
" slows things down for large files, e.g. over 2000 lines. I don't think there
" is any reason that I really need to parse the entire file, and 300 lines seems
" like a good default, so let's just use the default setting.
" let g:clojure_maxlines = 0


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
let g:conjure#log#hud#passive_close_delay = 1000

let g:conjure#highlight#enabled = v:true

let g:conjure#filetype#sicp = "conjure.client.racket.stdio"

" Disable the automatic Babashka REPL, as I never use it, and it causes problems
" if I'm trying to start my own REPL, but I happen to open Vim before my REPL
" server is up, and thus Conjure starts the Babashka REPL instead of connecting
" to my REPL.
let g:conjure#client#clojure#nrepl#connection#auto_repl#enabled = v:false

" NOTE 2022-02-22: Conjure does have a "toggle log" command, but it's documented
" that it only works for horizontal/vertical splits, and I prefer to view the
" log in the current window. I tried Conjure's "toggle log" command anyway, and
" I confirmed that it doesn't work if the log is full-screen.
function! ToggleConjureLog() abort
  if expand('%:t') =~ ".*conjure-log-.*"
    " For some reason, Bclose doesn't play nice with Conjure. Conjure's built-in
    " "close all log windows in current tab" mapping works as expected, though,
    " so we'll use that to close the log.
    "
    " Another thing worth noting: normal apparently doesn't work with <leader>
    " and <localleader>, so you have to do some hackery like what's going on
    " here (https://vi.stackexchange.com/a/7780/25687) or just give up and type
    " your actual (local)leader key in the mapping. I'm doing the second one.
    "
    " TODO: Is there some way to call the function provided by Conjure directly
    " instead of automating typing the mapping? That would be better because
    " this approach will break if I ever decide to change my configured
    " mappings (which is unlikely, though, so meh, this is fine).
    normal \lq
  else
    " See note above re: why I'm using a literal backslash here instead of
    " <localleader>, which would have been preferable.
    normal \lt
  endif
endfunction

augroup additional_conjure_bindings_etc
  autocmd!

  autocmd FileType clojure,fennel,janet,racket
        \ nnoremap <buffer>
        \ <localleader>cc :call ToggleConjureLog()<CR>

  " mnemonic: eval prompt
  " (like how <localleader>ee is eval expression)
  autocmd FileType clojure,fennel,janet,racket
        \ nnoremap <buffer>
        \ <localleader>ep :ConjureEval<space>

  " press q to close the log buffer
  " This uses the "close all log windows in current tab" mapping provided by
  " Conjure. I would use Bclose, but it doesn't play nicely with Conjure for
  " some reason.
  autocmd BufEnter conjure-log-* nmap <buffer> q <localleader>lq

  " Ensure that the log buffer's ft is set to Clojure. (I think Conjure used to
  " do this automatically, but then it stopped doing it for some reason.)
  autocmd BufEnter conjure-log-*.cljc set ft=clojure

  " Disable LSP diagnostics in the Conjure log buffer
  "
  " (vim.diagnostic.disable takes an optional argument which is the number of
  " the buffer to disable diagnostics in. 0 means the current buffer.)
  autocmd BufEnter conjure-log-* lua vim.diagnostic.disable(0)
augroup END


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
let g:ctrlsf_extra_backend_args = {'rg': '--hidden --glob !tags --glob !.git/'}
nmap <leader>f <Plug>CtrlSFPrompt
vmap <leader>f <Plug>CtrlSFVwordExec
nmap <leader>F :CtrlSFOpen<CR>:CtrlSFUpdate<CR>
nmap <leader>tD :CtrlSF -R TODO<bar>FIXME<CR>
nmap <leader>8 :CtrlSF -R '.{81,}'<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => elm-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:elm_format_autosave = 0


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


" Don't hide the sign column when there are no diagnostics/git changes. I like
" it better this way because otherwise, my text keeps going back and forth
" every time the diagnostics/gitgutter signs appear/disappear.
set signcolumn=yes

" If there are diagnostics in the sign column, I'd rather see those instead of
" the gitgutter signs.
let g:gitgutter_sign_allow_clobber = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gofmt
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I've read that goimports is basically just like gofmt, plus it organizes your
" imports and removes ones you aren't using. So, I prefer goimports over gofmt.
let g:gofmt_exe = 'goimports'


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


"""""""""""""""""""""""""""""""
" => Merlin (OCAML)
"""""""""""""""""""""""""""""""
if executable('opam')
  let g:opamshare = substitute(system('opam config var share 2>/dev/null'),'\n$','','''')
  execute "set rtp+=" . g:opamshare . "/merlin/vim"
endif


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
" => rust
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rustfmt_autosave = 1


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

" Only enable Vimwiki bindings when editing files in the path(s) above
let g:vimwiki_global_ext = 0

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
  " current directory in my directory browser.
  autocmd FileType vimwiki nmap ( <Plug>VimwikiRemoveHeaderLevel
  autocmd FileType vimwiki nmap ) <Plug>VimwikiAddHeaderLevel

  " This adds some functionality that vimwiki is missing: if there is no diary
  " entry for today yet, it creates a skeleton from a template.
  autocmd BufEnter *vimwiki/diary/*.wiki call CreateSkeletonDiaryEntry()
augroup end

" I don't use the diary.wiki diary index page. I prefer to browse the directory
" of diary entries. So, I'm remapping the keybinding that would otherwise open
" the diary index page. vimwiki is nice enough not to overwrite this when it
" loads.
nnoremap <leader>wi :e ~/Sync/vimwiki/diary/<CR>

" ,w,w feels a bit awkward. I like ,wt (mnemonic: "wiki today") better.  Vimwiki
" has its own ,wt mapping, but I never use it (it opens the wiki index page in a
" tab, and I don't really use tabs).
nmap <leader>wt <Plug>VimwikiMakeDiaryNote

" Now that I have a "wiki today" mapping, I also want "wiki yesterday" and "wiki
" tomorrow" mappings.
nmap <leader>wy <Plug>VimwikiMakeYesterdayDiaryNote
nmap <leader>wT <Plug>VimwikiMakeTomorrowDiaryNote


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
