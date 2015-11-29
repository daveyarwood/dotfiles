set shell=bash
set nocompatible
filetype off " required by Vundle

set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" aesthetic
Plugin 'altercation/vim-colors-solarized'
Plugin 'amix/vim-zenroom2'
Plugin 'bling/vim-airline'
Plugin 'flazz/vim-colorschemes'
Plugin 'gorodinskiy/vim-coloresque'
Plugin 'junegunn/goyo.vim'
Plugin 'ntpeters/vim-airline-colornum'

" editor enhancements
Plugin 'benmills/vimux'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'dyng/ctrlsf.vim'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'schickling/vim-bufonly'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimfiler.vim'
Plugin 'szw/vim-ctrlspace'
Plugin 'tommcdo/vim-lion'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'vim-scripts/gitignore'

" clojure things
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-salve'
Plugin 'vim-scripts/paredit.vim'
Plugin 'vim-scripts/vim-niji'

" language/filetype support
Plugin 'andreimaxim/vim-io'
Plugin 'cohama/lexima.vim'
Plugin 'dag/vim-fish'
Plugin 'daveyarwood/vim-alda'
Plugin 'fatih/vim-go'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mattn/emmet-vim'
Plugin 'matze/vim-lilypond'
Plugin 'tmux-plugins/vim-tmux'

" misc
Plugin 'chrisbra/unicode.vim'
Plugin 'gregsexton/gitv'
Plugin 'itchyny/calendar.vim'
Plugin 'jreybert/vimagit'
Plugin 'mhinz/vim-startify'
Plugin 'mileszs/ack.vim'
Plugin 'szw/vim-dict'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-fugitive'
Plugin 'vimwiki/vimwiki'

call vundle#end()
filetype plugin indent on

" ultimate vimrc stuff
set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry
