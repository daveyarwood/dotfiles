-- Leader and shell need to be set before plugins and mappings load.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.o.shell = "bash"

-- Neovim-specific odds & ends (previously in .nvimrc).

-- Open terminal buffers in insert mode.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() vim.cmd("startinsert") end,
})

-- When Escape is pressed while in terminal-normal mode, enter normal mode.
vim.keymap.set("t", "<esc>", "<C-\\><C-n><CR>")

-- Python providers.
vim.g.python_host_prog = "/usr/bin/python"
vim.g.python3_host_prog = "/usr/bin/python3"

-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugins (eagerly, preserving vim-plug's load-everything behavior).
require("lazy").setup({
  { import = "user.plugins" },
}, {
  defaults = { lazy = false },
  install = { colorscheme = { "gruvbox" } },
})

-- Source the Vimscript config (settings, mappings, filetypes, plugin config,
-- iabbrevs, colorscheme). Glob order is lexicographic, which matches the
-- numeric prefixes (000, 300, 400-406, 500, 600, 700).
local vim_dir = vim.fn.stdpath("config") .. "/vim"
for _, f in ipairs(vim.fn.glob(vim_dir .. "/*.vim", false, true)) do
  vim.cmd.source(f)
end

-- Load Lua configs (telescope, cmp, lsp, etc.).
require("user.config")
