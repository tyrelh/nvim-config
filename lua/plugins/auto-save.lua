vim.keymap.set('n', '<leader>ts', '<cmd>ASToggle<cr>', { noremap = true, silent = true, desc = '[T]oggle Auto[S]ave' })
return {
  'pocco81/auto-save.nvim',
  opts = {
    trigger_events = {
      'InsertLeave',
      'BufLeave',
      'ExitPre',
      'FocusLost',
    },
  },
}
