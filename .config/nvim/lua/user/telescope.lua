local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup {
  pickers = {
    buffers = { theme = "ivy" },
    diagnostics = { theme = "ivy" },
    find_files = { theme = "ivy" },
    git_files = { theme = "ivy" },
    help_tags = { theme = "ivy" },
    keymaps = { theme = "ivy" },
    live_grep = { theme = "ivy" },
    lsp_references = { theme = "ivy" },
    lsp_workspace_symbols = { theme = "ivy" },
    symbols = { theme = "ivy" },
  }
}

-- Extensions

telescope.load_extension("fzf")

-- Mappings

local nmap = require("user.fns").nmap

nmap("<leader>t<space>", ":Telescope ")
nmap("<leader>tt", ":Telescope<cr>")
nmap("<leader>tb", builtin.buffers)
-- The "julia" set is for characters like ¥ ° • ™ ¶ λ
nmap("<leader>tc", function() builtin.symbols{ sources = {"julia"} } end)
nmap("<leader>td", builtin.diagnostics)
nmap("<leader>te", function() builtin.symbols{ sources = {"emoji"} } end)
-- I had this bound to find_files at first, but that ignores hidden files that
-- are part of the project, e.g. .node-version, .clj-kondo/. I'm more likely to
-- want to jump to those files than I am to want to edit files that aren't in
-- source control.
--
-- find_files also includes all of the files in the submodules, which is
-- occasionally useful, but usually just noisy.
--
-- For those times when I do want to edit files not in source control (or files
-- in submodules), I can either run `:Telescope find_files` or simply navigate
-- there in my directory browser.
nmap("<leader>tf", builtin.git_files)
nmap("<leader>tg", builtin.live_grep)
nmap("<leader>th", builtin.help_tags)
nmap("<leader>tm", builtin.keymaps)
nmap("<leader>tr", builtin.lsp_references)
nmap("<leader>ts", builtin.lsp_workspace_symbols)

-- Because I jump around so much, it's nice to have a short mapping for this
nmap("<c-f>", builtin.git_files)
