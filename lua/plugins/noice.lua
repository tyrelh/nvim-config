vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<cr>', { desc = '[N]oice [D]ismiss', noremap = true, silent = true })
return {
  -- https://github.com/folke/noice.nvim
  -- Taken from https://www.youtube.com/watch?v=upM6FOtdLeU
  -- That video also talks about a comand cmp plugin to give you autocompletes
  -- for comamnds and searches
  {
    'folke/noice.nvim',
    -- event = 'VeryLazy',
    opts = {
      -- display recording messages in notifications
      routes = {
        view = 'notify',
        filter = { event = 'msg_showmode' },
      },
      -- clean command line
      views = {
        cmdline_popup = {
          border = {
            -- style = 'shadow',
            padding = { 1, 2 },
          },
        },
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim', -- https://github.com/rcarriga/nvim-notify?tab=readme-ov-file#configuration
      {
        'rcarriga/nvim-notify',
        opts = {
          background_colour = '#000000', -- fix dumb warning message
          timeout = 3000,
          stages = 'slide',
          render = 'compact',
        },
      },
    },
  },
}
