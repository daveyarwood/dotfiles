-- Plugin spec for lazy.nvim.
--
-- Migrated 1:1 from the old vim-plug list (.vim/custom/100-plugins.vim).
-- Everything is loaded eagerly (see `defaults = { lazy = false }` in init.lua)
-- to preserve vim-plug's load-everything behavior until lazy-loading is added
-- deliberately.

return {
  -- aesthetic -----------------------------------------------------------------
  { "ayu-theme/ayu-vim" },
  { "cormacrelf/vim-colors-github" },
  { "MeanderingProgrammer/render-markdown.nvim" },
  { "m00qek/baleia.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "rrethy/vim-hexokinase", build = "make hexokinase" },
  { "sonph/onehalf", rtp = "vim/" },
  { "vim-scripts/mayansmoke" },

  -- neovim / lua / lsp --------------------------------------------------------
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip", tag = "v2.*", build = "make install_jsregexp" },
  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "neovim/nvim-lspconfig" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" } },
  { "nvim-telescope/telescope-symbols.nvim" },
  { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
  { "PaterJason/cmp-conjure" },
  { "saadparwaiz1/cmp_luasnip" },

  -- clojure -------------------------------------------------------------------
  { "eraserhd/parinfer-rust", build = "cargo build --release" },
  { "guns/vim-clojure-static" },
  { "guns/vim-sexp" },
  { "luochen1990/rainbow" },
  { "Olical/conjure" },
  { "tpope/vim-sexp-mappings-for-regular-people" },

  -- other languages / filetypes ----------------------------------------------
  { "adimit/prolog.vim" },
  { "aklt/plantuml-syntax" },
  { "bakpakin/fennel.vim" },
  { "cespare/vim-toml" },
  { "dag/vim-fish" },
  { "dart-lang/dart-vim-plugin" },
  { "daveyarwood/vim-alda" },
  { "derekwyatt/vim-scala" },
  { "digitaltoad/vim-pug" },
  { "dleonard0/pony-vim-syntax" },
  { "dpwright/vim-tup" },
  { "elixir-lang/vim-elixir" },
  { "ElmCast/elm-vim" },
  { "evanleck/vim-svelte", branch = "main" },
  { "habamax/vim-asciidoctor" },
  { "HerringtonDarkholme/yats.vim" },
  { "idris-hackers/idris-vim" },
  { "iloginow/vim-stylus" },
  { "IoLanguage/io", rtp = "extras/SyntaxHighlighters/Vim", submodules = false },
  { "jceb/vim-orgmode" },
  { "jdonaldson/vaxe" },
  { "JuliaEditorSupport/julia-vim" },
  { "junegunn/vader.vim" },
  { "kchmck/vim-coffee-script" },
  { "keith/swift.vim" },
  { "lfe/vim-lfe" },
  { "mattn/emmet-vim" },
  { "matze/vim-lilypond" },
  { "mustache/vim-mustache-handlebars" },
  { "othree/html5.vim" },
  { "pangloss/vim-javascript" },
  { "PProvost/vim-ps1" },
  { "raichoo/purescript-vim" },
  { "reasonml-editor/vim-reason-plus" },
  { "rhysd/vim-crystal" },
  { "rust-lang/rust.vim" },
  { "stephencelis/vim-mml" },
  { "tfnico/vim-gradle" },
  { "tmux-plugins/vim-tmux" },
  { "tweekmonster/gofmt.vim" },
  { "udalov/kotlin-vim" },
  { "vlime/vlime", rtp = "vim/" },
  { "wlangstroth/vim-racket" },
  { "zah/nim.vim" },

  -- misc ----------------------------------------------------------------------
  { "AndrewRadev/splitjoin.vim" },
  { "benmills/vimux" },
  { "chrisbra/unicode.vim" },
  { "christoomey/vim-tmux-navigator" },
  { "CopilotC-Nvim/CopilotChat.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "dyng/ctrlsf.vim" },
  { "embear/vim-localvimrc" },
  { "zbirenbaum/copilot-cmp" },
  { "zbirenbaum/copilot.lua" },
  { "iamcco/markdown-preview.nvim", build = "cd app && npx --yes yarn install" },
  { "jiangmiao/auto-pairs" },
  { "jreybert/vimagit" },
  { "kshenoy/vim-signature" },
  { "lambdalisue/gina.vim" },
  { "machakann/vim-sandwich" },
  { "ntpeters/vim-better-whitespace" },
  { "schickling/vim-bufonly" },
  { "stevearc/oil.nvim" },
  { "tommcdo/vim-lion" },
  { "tpope/vim-commentary" },
  { "tpope/vim-endwise" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-repeat" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-unimpaired" },
  { "tyru/open-browser.vim" },
  { "vim-scripts/gitignore" },
  { "vimwiki/vimwiki",
    init = function()
      -- vimwiki snapshots g:vimwiki_* into g:vimwiki_global_vars when its
      -- plugin script loads, and lazy.nvim loads plugins before sourcing the
      -- Vimscript config (500-plugins-config.vim). So these must live in
      -- `init`, which lazy runs before vimwiki loads.
      vim.g.vimwiki_list = { { path = "~/Sync/vimwiki", path_html = "~/Sync/vimwiki/html" } }
      vim.g.vimwiki_global_ext = 0
      -- Neovim's TUI menu model doesn't register the "Vimwiki.Table" submenu
      -- vimwiki expects to `nmenu enable/disable` on buffer enter/leave, so it
      -- throws E329. Disable the menu entirely; I never use a GUI menu bar.
      vim.g.vimwiki_menu = ""
    end,
  },
}
