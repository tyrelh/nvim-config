return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      component_separators = '',
      section_separators = { left = '', right = '' },
      theme = 'catppuccin',
      -- disabled_filetypes = { 'NvimTree' },
    },
    sections = {
      lualine_a = {
        { 'mode', separator = { left = '' }, right_padding = 2 },
      },
      lualine_b = {
        { 'filetype', icon_only = false, right_padding = 0 },
        {
          'filename',
          symbols = {
            modified = '',
            readonly = '󰷤 RO',
            unnamed = '󰊠', -- unnamed buffers.
            newfile = '', -- newly created file before first write
          },
          left_padding = 0,
        },
        { 'branch', icon = '' },
        { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } },
        'diagnostics',
      },
      lualine_c = {},

      lualine_x = {},
      lualine_y = {
        { 'progress', icon = '' },
      },
      lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 0 },
      },
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {
      'nvim-tree',
    },
  },
}
