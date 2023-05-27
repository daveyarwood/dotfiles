local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup {}

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
nmap("<leader>tf", builtin.find_files)
nmap("<leader>tg", builtin.live_grep)
nmap("<leader>th", builtin.help_tags)
nmap("<leader>tm", builtin.keymaps)
nmap("<leader>ts", builtin.lsp_workspace_symbols)

-- Because I jump around so much, it's nice to have a short mapping for this
nmap("<c-f>", builtin.find_files)
