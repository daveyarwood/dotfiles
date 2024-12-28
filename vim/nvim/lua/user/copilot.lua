require('copilot').setup({
  panel = { enabled = false },
  suggestion = { enabled = false },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    -- gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})

-- For example config, see:
-- https://github.com/deathbeam/dotfiles/blob/master/nvim/.config/nvim/lua/config/copilot.lua
require("CopilotChat").setup {}
