-- This plugin makes it easier to read diagnostics when there are more than one
-- per line.
require("lsp_lines").setup()

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

-- Fancier diagnostic signs in the gutter on the left
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

----- Language servers -----

local lspconfig = require("lspconfig")
local cmp_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.bashls.setup {
  capabilities = cmp_lsp_capabilities
}

lspconfig.clojure_lsp.setup {
  capabilities = cmp_lsp_capabilities
}

lspconfig.gopls.setup {
  capabilities = cmp_lsp_capabilities,
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

require'lspconfig'.lua_ls.setup {
  capabilities = cmp_lsp_capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique
      -- identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.solargraph.setup {
  capabilities = cmp_lsp_capabilities
}

lspconfig.tsserver.setup {
  capabilities = cmp_lsp_capabilities
}
