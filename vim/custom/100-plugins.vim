call plug#begin('~/.vim/bundle')

" aesthetic
Plug 'ayu-theme/ayu-vim'
Plug 'chrisbra/Colorizer'
Plug 'cormacrelf/vim-colors-github'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'vim-scripts/mayansmoke'

" editor enhancements
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dyng/ctrlsf.vim'
Plug 'gerw/vim-HiLinkTrace'
Plug 'godlygeek/tabular'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'kassio/neoterm'
Plug 'kshenoy/vim-signature'
Plug 'liuchengxu/vista.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'schickling/vim-bufonly'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'unblevable/quick-scope'
Plug 'vim-scripts/gitignore'
Plug 'w0rp/ale'

" clojure things
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'luochen1990/rainbow'
Plug 'Olical/conjure', { 'do': 'bin/compile', 'for': 'clojure', 'on': 'ConjureUp' }
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" other languages/filetypes
Plug 'adimit/prolog.vim'
Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'dart-lang/dart-vim-plugin'
Plug 'daveyarwood/vim-alda'
Plug 'derekwyatt/vim-scala'
Plug 'digitaltoad/vim-pug'
Plug 'dleonard0/pony-vim-syntax'
Plug 'dpwright/vim-tup'
Plug 'elixir-lang/vim-elixir'
Plug 'ElmCast/elm-vim'
Plug 'habamax/vim-asciidoctor'
Plug 'idris-hackers/idris-vim'
Plug 'iloginow/vim-stylus'
Plug 'IoLanguage/io', { 'rtp': 'extras/SyntaxHighlighters/Vim' }
Plug 'jceb/vim-orgmode'
Plug 'jdonaldson/vaxe'
Plug 'jtratner/vim-flavored-markdown'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'junegunn/vader.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'lfe/vim-lfe'
Plug 'l04m33/vlime', {'rtp': 'vim/'}
Plug 'mattn/emmet-vim'
Plug 'matze/vim-lilypond'
Plug 'mustache/vim-mustache-handlebars'
Plug 'OrangeT/vim-csharp'
Plug 'PProvost/vim-ps1'
Plug 'raichoo/purescript-vim'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'rhysd/vim-crystal'
Plug 'rust-lang/rust.vim'
Plug 'stephencelis/vim-mml'
Plug 'tfnico/vim-gradle'
Plug 'tmux-plugins/vim-tmux'
Plug 'udalov/kotlin-vim'
Plug 'wlangstroth/vim-racket'
Plug 'zah/nim.vim'

" misc
Plug 'chrisbra/unicode.vim'
Plug 'jreybert/vimagit'
Plug 'junegunn/gv.vim'
Plug 'lambdalisue/gina.vim'
Plug 'mileszs/ack.vim'
Plug 'szw/vim-dict'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tyru/open-browser.vim'
Plug 'Valloric/ListToggle'
Plug 'vimwiki/vimwiki'

call plug#end()
