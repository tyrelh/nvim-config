return {
  -- https://github.com/folke/noice.nvim
  -- Clean floating command line
  -- Taken from https://www.youtube.com/watch?v=upM6FOtdLeU
  -- That video also talks about a comand cmp plugin to give you autocompletes
  -- for comamnds and searches
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      messages = {
        -- enabled = false,
      },
      notify = {
        -- enabled = false,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim', -- https://github.com/rcarriga/nvim-notify?tab=readme-ov-file#configuration
      {
        'rcarriga/nvim-notify',
        opts = {
          background_colour = '#000000',
          timeout = 3000,
          stages = 'slide',
          -- render = 'compact',
        },
      },
    },
  },
}
