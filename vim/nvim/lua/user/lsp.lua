-- This plugin makes it easier to read diagnostics when there are more than one
-- per line.
require("lsp_lines").setup()

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

local lspconfig = require("lspconfig")

lspconfig.clojure_lsp.setup{}

lspconfig.gopls.setup {
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

lspconfig.solargraph.setup{}

