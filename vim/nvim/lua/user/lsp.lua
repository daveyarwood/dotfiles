----- Auxiliary / LSP-adjacent plugins -----

-- This plugin makes it easier to read diagnostics when there are more than one
-- per line.
local lsp_lines = require("lsp_lines")
lsp_lines.setup()

vim.diagnostic.config({
  -- Disable virtual_text since it's redundant due to lsp_lines.
  virtual_text = false,
  -- Fancier diagnostic signs in the gutter on the left
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "🅴 ",
      [vim.diagnostic.severity.WARN] = "🆆 ",
      [vim.diagnostic.severity.INFO] = "🅸 ",
      [vim.diagnostic.severity.HINT] = "🅷 ",
    }
  }
})

----- Mappings -----

local nmap = require("user.fns").nmap

nmap("gd", vim.lsp.buf.definition)
nmap("K", vim.lsp.buf.hover)
-- Because Conjure overwrites K, I also define the LSP hover as gK. That way, I
-- can use either one when I'm working on Clojure code, depending on whether or
-- not I have a REPL running.
nmap("gK", vim.lsp.buf.hover)
nmap("gr", vim.lsp.buf.references)
nmap("[d", vim.diagnostic.goto_prev)
nmap("]d", vim.diagnostic.goto_next)

-- lsp_lines can be noisy when there are a lot of findings, so provide an easy
-- binding to toggle it as needed
nmap("<leader>l", lsp_lines.toggle)

----- Language servers -----

-- Temporarily disable file watcher to keep clojure-lsp from hanging
-- Ref: https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
--
-- The downside of doing this is that LSP does not automatically update when
-- changes to files happen outside of Neovim, e.g. when switching branches.
--
-- TODO: Try removing this workaround whenever the issue above is resolved.
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
   -- disable lsp watcher. Too slow on linux
   wf._watchfunc = function()
     return function() end
   end
end

local lspconfig = require("lspconfig")
local cmp_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.bashls.setup {
  capabilities = cmp_lsp_capabilities
}

lspconfig.clojure_lsp.setup {
  capabilities = cmp_lsp_capabilities
}

lspconfig.eslint.setup {
  -- I don't _think_ this part is relevant for eslint. I think ts_ls should
  -- handle all of the completions.
  -- capabilities = cmp_lsp_capabilities
  command = "eslint_d"
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

-- 2024-02-03: I tried Kotlin language server and it mostly works, but there are
-- some issues with resolving referencies from dependencies. I dug through the
-- :LspInfo output and saw an "unsupported major version" error, which means my
-- Java version (currently 17) isn't supported.
--
-- I found this related issue:
-- https://github.com/fwcd/kotlin-language-server/issues/474
--
-- The workaround is to use Java 11, but I'm currently enjoying not having to
-- manage multiple Java versions, so I'm just going to disable Kotlin language
-- server for now.
--
-- TODO: Revisit in the future.
--
-- lspconfig.kotlin_language_server.setup{
--   capabilities = cmp_lsp_capabilities,
-- }

lspconfig.lua_ls.setup {
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

lspconfig.rust_analyzer.setup{}

lspconfig.solargraph.setup {
  capabilities = cmp_lsp_capabilities
}

lspconfig.ts_ls.setup {
  capabilities = cmp_lsp_capabilities
}
