-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Copy/paste
-- vim.keymap.set('n', '<leader>p', '"+p', { desc = '[p]aste from clipboard' })
-- vim.keymap.set('n', '<leader>y', '"+y', { desc = '[y]ank to clipboard' })

vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Exit Insert Mode' })
vim.keymap.set('i', 'ii', '<ESC>', { desc = 'Exit Insert Mode' })

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
