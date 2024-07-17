vim.keymap.set('v', 'J', ':MoveBlock(1)<CR>', { desc = 'Move block down', noremap = true, silent = true })
vim.keymap.set('v', 'K', ':MoveBlock(-1)<CR>', { desc = 'Move block up', noremap = true, silent = true })

-- https://github.com/fedepujol/move.nvim
return {
  'fedepujol/move.nvim',
  opts = {},
}
