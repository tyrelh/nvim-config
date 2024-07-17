-- Copy/paste
-- vim.keymap.set('n', '<leader>p', '"+p', { desc = '[p]aste from clipboard' })
-- vim.keymap.set('n', '<leader>y', '"+y', { desc = '[y]ank to clipboard' })

vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Exit Insert Mode' })
vim.keymap.set('i', 'ii', '<ESC>', { desc = 'Exit Insert Mode' })

-- vim.keymap.set('n', '<leader>t', '<cmd> tabn <CR>', { desc = 'Next [T]ab' })

vim.keymap.set('n', '<S-l>', '<cmd> bnext <CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-h>', '<cmd> bprevious <CR>', { desc = 'Previous Buffer' })

-- Move text
-- vim.keymap.set('n', '<C-j>', '<cmd> m .+1<CR>==', { desc = 'Move line down' })
-- vim.keymap.set('n', '<C-k>', '<cmd> m .-2<CR>==', { desc = 'Move line up' })
-- vim.keymap.set('v', 'J', "<cmd> m '>+1<CR>gv=gv", { desc = 'Move line down' })
-- vim.keymap.set('v', 'K', "<cmd> m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- past over currently selected text without yanking it
vim.keymap.set('v', 'p', '"_dp', { desc = 'Paste over' })
vim.keymap.set('v', 'P', '"_dP', { desc = 'Paste over' })

-- save like you are used to
vim.keymap.set({ 'i', 'n', 'v', 's' }, '<C-s>', '<cmd>w<CR><esc>', { desc = 'Save' })

return {}
