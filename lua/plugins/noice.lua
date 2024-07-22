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
      background_colour = '#000000',
      messages = {
        -- enabled = false,
      },
      notify = {
        -- enabled = false,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
}
