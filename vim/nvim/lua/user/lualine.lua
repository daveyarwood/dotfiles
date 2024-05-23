require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'everforest',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
     {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = " " },
        diagnostics_color = {
          error = { fg = '#f00000' },
          warn = { fg = '#fda500' },
          info = { fg = '#88aabb' },
        },
      },
    },
    lualine_c = {
      'filename',
      -- LSP server name
      {
        function()
          local no_lsp = ''
          local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then
            return no_lsp
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return " " .. client.name
            end
          end
          return no_lsp
        end,
      }
    },
    lualine_x = {
      'encoding',
      {
        'fileformat',
        symbols = {
          unix = "unix",
          dos = "dos",
          mac = "mac"
        }
      },
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

return {
  -- Provide a function that I can call from the Vimscript side when toggling my
  -- colorscheme. (See ToggleColorschemeMode)
  set_lualine_theme = function(theme)
    local config = require('lualine').get_config()
    config.options.theme = theme
    require('lualine').setup(config)
  end
}
