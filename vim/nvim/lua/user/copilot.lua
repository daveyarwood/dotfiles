local selected_model = 'claude-sonnet-4.5'

require('copilot').setup({
  panel = { enabled = false },
  suggestion = { enabled = false },
  filetypes = {
    yaml = true,
    markdown = true,
    help = false,
    gitcommit = true,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  -- 2026-02-10: It appears that there is only one model that can be used for
  -- completion, gpt-41-copilot. If I can't use Claude for completion, then I
  -- don't really care which model it uses, so I'll just rely on whatever is the
  -- default model.
  --
  -- In the future, if they give us choices, I can use this option to specify
  -- which model I want to use.
  --
  -- Ref: https://github.com/zbirenbaum/copilot.lua/issues/649
  --
  -- copilot_model = selected_model,
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})

-- For example config, see:
-- https://github.com/deathbeam/dotfiles/blob/master/nvim/.config/nvim/lua/config/copilot.lua
require("CopilotChat").setup {
  model = selected_model,
  mappings = {
    -- Disable this mapping because it's `<C-l>` by default, and I use that to
    -- move between Vim windows / tmux panes.
    reset = { normal = '', insert = '' },
    -- Disable this mapping because it's `gj` by default, and that conflicts
    -- with moving the cursor down! I have my `j` mapped to `gj`, so this is a
    -- problem for me.
    jump_to_diff = { normal = '' },
  }
}

local nmap = require("user.fns").nmap

nmap("<leader>c", ":CopilotChatToggle<cr>")
