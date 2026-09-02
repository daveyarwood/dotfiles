local nmap = require("user.fns").nmap
local oil = require("oil")

---- Show git-tracked hidden files ----

-- Reference:
-- https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files

-- helper function to parse output
local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
      -- Remove trailing slash
      line = line:gsub("/$", "")
      ret[line] = true
    end
  end
  return ret
end

-- build git status cache
local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        {
          cwd = key,
          text = true,
        }
      )
      local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
        cwd = key,
        text = true,
      })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }

      rawset(self, key, ret)
      return ret
    end,
  })
end
local git_status = new_git_status()

-- Clear git status cache on refresh
local refresh = require("oil.actions").refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
  git_status = new_git_status()
  orig_refresh(...)
end

-------------------------------------

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
    ["~"] = "actions.cd",
    -- Disable <C-h> and <C-l> so they don't conflict with vim-tmux-navigator
    ["<C-h>"] = false,
    ["<C-l>"] = false
  },
  view_options = {
    is_hidden_file = function(name, bufnr)
      local dir = require("oil").get_current_dir(bufnr)
      local is_dotfile = vim.startswith(name, ".") and name ~= ".."
      -- if no local directory (e.g. for ssh connections), just hide dotfiles
      if not dir then
        return is_dotfile
      end
      -- dotfiles are considered hidden unless tracked
      if is_dotfile then
        return not git_status[dir].tracked[name]
      else
        -- Check if file is gitignored
        return git_status[dir].ignored[name]
      end
    end,
  },
}

nmap("-", oil.open)
