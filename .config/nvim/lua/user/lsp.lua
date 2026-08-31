----- Diagnostic config -----

vim.diagnostic.config({
  virtual_lines = true,
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
nmap("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
nmap("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)

-- Virtual line diagnostics can be noisy when there are a lot of findings, so
-- provide an easy binding to toggle them as needed.
nmap("<leader>l", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end)

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

local enable_lsp = function(server_name, config)
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

local cmp_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

enable_lsp('bashls', { capabilities = cmp_lsp_capabilities })

enable_lsp('clojure_lsp', { capabilities = cmp_lsp_capabilities })

-- 2025-09-19: I started getting a cryptic error after updating nvim-lspconfig
-- and/or Neovim itself. Gemini did some research and suggested that I set
-- `root_dir` to `require('lspconfig.util').find_git_ancestor`. So I tried that,
-- but there was a deprecation warning saying to use this disgusting code
-- instead.
--
-- Whatever, it works now.
local root_dir = vim.fs.dirname(vim.fs.find(
  '.git',
  { path = vim.fn.expand('%:p:h'), upward = true }
)[1])

-- JS/TS linting: I enable both eslint and oxlint. Each language server
-- self-gates via its own root_dir logic, only attaching when it finds the
-- corresponding config in the project tree (eslint.config.* / .eslintrc* for
-- eslint, oxlint.config.* / .oxlintrc.json for oxlint). This keeps the config
-- portable across projects that use either toolchain, without me having to
-- toggle anything.
--
-- eslint's LSP defaults to format = true (it exposes `eslint --fix` as a
-- formatting provider), but eslint is a linter, not a formatter, so I disable
-- that. This keeps eslint out of the formatting picture entirely, which matters
-- because I standardize on LSP formatting (see the format-on-save autocmd
-- below): only genuine formatter LSPs like oxfmt should ever format.
enable_lsp('eslint', {
  -- ts_ls handles completions, so no cmp capabilities needed here.
  settings = {
    format = false,
  },
})

-- Resolve a project-local CLI binary by walking up from the current buffer's
-- file to the nearest `node_modules/.bin/<tool>`. Falls back to the bare tool
-- name (PATH lookup) if none is found.
--
-- This is needed because lspconfig's bundled oxlint/oxfmt configs only prefer
-- the local binary when their `root_dir` happens to point at the directory that
-- contains `node_modules/.bin`. In monorepos like spark, `root_dir` can resolve
-- to a subpackage (e.g. web/) that has no local bin, so the bundled `cmd` would
-- fall back to PATH and fail to spawn. Walking up from the file itself is
-- layout-agnostic and works across any project.
local function local_bin_cmd(tool)
  return function(dispatchers, config)
    local cmd = tool
    local fname = vim.api.nvim_buf_get_name(0)
    local start = fname ~= '' and vim.fs.dirname(fname) or (config or {}).root_dir
    local bin = start and vim.fs.find(
      vim.fs.joinpath('node_modules', '.bin', tool),
      { path = start, upward = true }
    )[1]
    if bin and vim.fn.executable(bin) == 1 then
      cmd = bin
    end
    return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
  end
end

enable_lsp('oxlint', {
  capabilities = cmp_lsp_capabilities,
  cmd = local_bin_cmd('oxlint'),
})

enable_lsp('ts_ls', {
  capabilities = cmp_lsp_capabilities,
  root_dir = root_dir,
  -- ts_ls advertises formatting, but its TypeScript-language-service formatter
  -- is not what I want. I standardize on LSP formatting (see the format-on-save
  -- autocmd below) and let oxfmt be the formatter, so disable ts_ls formatting
  -- to keep it out of the formatting picture.
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

enable_lsp('gopls', {
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
})

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
-- enable_lsp('kotlin_language_server', {
--   capabilities = cmp_lsp_capabilities,
-- })

enable_lsp('lua_ls', {
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
})

enable_lsp('rust_analyzer', {})

enable_lsp('solargraph', { capabilities = cmp_lsp_capabilities })

-- JS/TS formatting: oxfmt runs as an LSP formatter and self-gates the same way
-- oxlint does (only attaches when it finds an oxfmt config in the project
-- tree). In projects that use it (e.g. spark), oxfmt formats on save via the
-- autocmd below.
enable_lsp('oxfmt', {
  cmd = local_bin_cmd('oxfmt'),
})

----- Format on save (JS/TS/JSON) -----

-- I standardize on LSP formatting. Every LSP that is not a real formatter is
-- kept out of the formatting picture (eslint via format = false, ts_ls via
-- on_attach above), so the only client that can format is a genuine formatter
-- LSP such as oxfmt. That makes a bare vim.lsp.buf.format() correct: it formats
-- with oxfmt in oxfmt projects, and is a no-op in projects that have no
-- formatter LSP attached (e.g. prettier/eslint projects I haven't migrated to
-- oxfmt yet).
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('format_js_code_on_save', { clear = true }),
  pattern = { '*.json', '*.js', '*.jsx', '*.ts', '*.tsx' },
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf })
  end,
})
