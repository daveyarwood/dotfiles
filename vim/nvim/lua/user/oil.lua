local nmap = require("user.fns").nmap
local oil = require("oil")

oil.setup {
  -- ID is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {"icon"},
  keymaps = {
    -- By default, Ctrl-S opens the selected file in a vertical split, but I
    -- don't really use splits, and I already have a Ctrl-S mapping elsewhere
    -- that saves the current buffer, which is especially useful in Oil.
    ["<C-s>"] = false,
    -- By default, ` sets the cwd to the current Oil directory via :cd, and ~
    -- does the same thing via :tcd (which is like :cd, except only for the
    -- current tab). I don't use tabs, so the :cd version is more useful for me,
    -- but I like the ~ mapping better because it reminds me of home.
    ["`"] = false,
    ["~"] = "actions.cd"
  }
}

nmap("-", oil.open)
