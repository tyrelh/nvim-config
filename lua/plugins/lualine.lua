return {
  {
    'AndreM222/copilot-lualine',
    dependencies = { 'zbirenbaum/copilot.lua' },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'folke/noice.nvim' },
    opts = {
      options = {
        component_separators = '',
        section_separators = { left = '', right = '' },
        theme = 'catppuccin',
        disabled_filetypes = { 'alpha' },
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { left = '', right = '' }, padding = 0 },
        },
        lualine_b = {
          { 'location', padding = 0 },
          { 'progress', icon = '', padding = 0 },
          { 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
          -- {
          --   'filename',
          --   symbols = {
          --     modified = '',
          --     readonly = '󰷤',
          --     unnamed = '󰊠', -- unnamed buffers.
          --     newfile = '', -- newly created file before first write
          --   },
          --   left_padding = 0,
          -- },
        },
        lualine_c = {
          {
            require('noice').api.statusline.mode.get,
            cond = require('noice').api.statusline.mode.has,
            color = { fg = '#ff9e64' },
          },
        },

        lualine_x = {},
        lualine_y = {
          'diagnostics',
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
          },
          { 'branch', icon = '' },
        },
        lualine_z = {
          { 'copilot', separator = { left = '', right = '' } },
        },
      },
      inactive_sections = {
        lualine_a = { 'location', 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          { 'branch', icon = '' },
        },
        lualine_z = {},
      },
      tabline = {},
      extensions = {
        'nvim-tree',
        'neo-tree',
        'toggleterm',
      },
    },
  },
}
