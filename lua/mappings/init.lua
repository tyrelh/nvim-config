-- Copy/paste
-- vim.keymap.set('n', '<leader>p', '"+p', { desc = '[p]aste from clipboard' })
-- vim.keymap.set('n', '<leader>y', '"+y', { desc = '[y]ank to clipboard' })

-- vim.keymap.set('n', '<leader>t', '<cmd> tabn <CR>', { desc = 'Next [T]ab' })

vim.keymap.set('n', '<S-l>', '<cmd> bnext <CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-h>', '<cmd> bprevious <CR>', { desc = 'Previous Buffer' })

return {}
