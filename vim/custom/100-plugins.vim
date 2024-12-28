call plug#begin('~/.vim/bundle')

" aesthetic
Plug 'ayu-theme/ayu-vim'
Plug 'cormacrelf/vim-colors-github'
Plug 'm00qek/baleia.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'vim-scripts/mayansmoke'

" new neovim / lua / lsp-related stuff
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim' " Dependency of telescope
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'PaterJason/cmp-conjure'
Plug 'saadparwaiz1/cmp_luasnip'

" clojure things
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'luochen1990/rainbow'
Plug 'Olical/conjure'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" other languages/filetypes
Plug 'adimit/prolog.vim'
Plug 'aklt/plantuml-syntax'
Plug 'bakpakin/fennel.vim'
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
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'habamax/vim-asciidoctor'
Plug 'idris-hackers/idris-vim'
Plug 'iloginow/vim-stylus'
Plug 'IoLanguage/io', { 'rtp': 'extras/SyntaxHighlighters/Vim' }
Plug 'jceb/vim-orgmode'
Plug 'jdonaldson/vaxe'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'junegunn/vader.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'keith/swift.vim'
Plug 'lfe/vim-lfe'
Plug 'mattn/emmet-vim'
Plug 'matze/vim-lilypond'
Plug 'mustache/vim-mustache-handlebars'
Plug 'othree/html5.vim' " dependency for vim-svelte
Plug 'OrangeT/vim-csharp'
Plug 'pangloss/vim-javascript'
Plug 'PProvost/vim-ps1'
Plug 'raichoo/purescript-vim'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'rhysd/vim-crystal'
Plug 'rust-lang/rust.vim'
Plug 'stephencelis/vim-mml'
Plug 'tfnico/vim-gradle'
Plug 'tmux-plugins/vim-tmux'
Plug 'tweekmonster/gofmt.vim'
Plug 'udalov/kotlin-vim'
Plug 'vlime/vlime', {'rtp': 'vim/'}
Plug 'wlangstroth/vim-racket'
Plug 'zah/nim.vim'

" misc
Plug 'benmills/vimux'
Plug 'chrisbra/unicode.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dyng/ctrlsf.vim'
Plug 'embear/vim-localvimrc'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'jiangmiao/auto-pairs'
Plug 'jreybert/vimagit'
Plug 'kshenoy/vim-signature'
Plug 'lambdalisue/gina.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sbdchd/neoformat'
Plug 'schickling/vim-bufonly'
Plug 'stevearc/oil.nvim'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'tyru/open-browser.vim'
Plug 'vim-scripts/gitignore'
Plug 'vimwiki/vimwiki'

call plug#end()
