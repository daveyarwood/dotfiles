" I used to use this plugin for this:
" https://github.com/machakann/vim-highlightedyank
"
" Then the maintainer of that plugin helpfully pointed out in the README that
" this feature is now available out-of-the-box with Neovim:
" https://neovim.io/doc/user/lua.html#lua-highlight

au TextYankPost * silent!
      \ lua vim.highlight.on_yank {higroup="IncSearch", timeout=250}
