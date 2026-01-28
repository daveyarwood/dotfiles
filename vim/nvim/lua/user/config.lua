-- A newer setting that controls the default border style for floating windows,
-- such as the ones used by LSP hover and signature help.
--
-- See:
-- https://www.reddit.com/r/neovim/comments/1jeg8v4/just_merged_an_option_to_control_the_default/
vim.o.winborder = "rounded"

require("user.baleia")
require("user.cmp")
require("user.copilot")
require("user.gitsigns")
require("user.lsp")
require("user.lualine")
require("user.oil")
require("user.telescope")
