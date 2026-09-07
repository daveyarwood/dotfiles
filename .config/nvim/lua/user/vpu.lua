-- Headless plugin updater with a summary. Used by the `vpu` fish function.
--
-- Runs `:Lazy update` (whose task/process output goes to stdout as usual), then
-- prints a summary of the plugins whose checked-out commit actually moved.
--
-- Why key on `plugin._.updated`: lazy.nvim updates plugins by
-- `git checkout <commit>`, which leaves the repo in a detached HEAD. On the
-- next update that detached HEAD makes lazy re-run checkout on the *same*
-- commit (printing "HEAD is now at ..." even though nothing changed). Those
-- phantom updates have `from == to`, so they're filtered out here.
local M = {}

function M.update()
  local Config = require("lazy.core.config")

  require("lazy").update({ wait = true, show = false })

  local names = {}
  for _, plugin in pairs(Config.plugins) do
    local u = plugin._.updated
    if u and u.from and u.to and u.from ~= u.to then
      table.insert(names, plugin.name)
    end
  end
  table.sort(names)

  io.write("\n")
  if #names == 0 then
    io.write("No plugins updated.\n")
    return
  end

  io.write("Updated:\n")
  for _, name in ipairs(names) do
    local plugin = Config.plugins[name]
    local commit = plugin._.updated.to
    local line = vim.trim(vim.fn.system({
      "git",
      "-C",
      plugin.dir,
      "show",
      "-s",
      "--format=%h %s (%cs)",
      "--no-show-signature",
      commit,
    }))
    if line == "" then
      line = commit:sub(1, 7)
    end
    io.write("  " .. name .. ": " .. line .. "\n")
  end
end

return M
