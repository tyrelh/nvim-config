vim.keymap.set('n', '<S-l>', '<cmd>BufferNext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-h>', '<cmd>BufferPrevious<cr>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<S-m>', '<cmd>BufferPick<cr>', { desc = 'Pick Buffer' })
vim.keymap.set('n', '<S-q>', '<cmd>BufferClose<cr>', { desc = 'Close Buffer' })

return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {},
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
  exclude_ft = { 'alpha' },
}
