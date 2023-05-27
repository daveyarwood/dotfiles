----- Auxiliary / LSP-adjacent plugins -----

-- This plugin makes it easier to read diagnostics when there are more than one
-- per line.
local lsp_lines = require("lsp_lines")
lsp_lines.setup()

vim.diagnostic.config({
  -- Disable virtual_text since it's redundant due to lsp_lines.
  virtual_text = false,
})

-- Fancier diagnostic signs in the gutter on the left
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

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

local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", {
  clear = false
})
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      -- Format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end
  end,
})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier',
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  ["null-ls"] = {
    condition = function()
      return prettier.config_exists({
        -- if `false`, skips checking `package.json` for `"prettier"` key
        check_package_json = true,
      })
    end,
    runtime_condition = function(_params)
      _ = _params
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  }
})
