return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'yamlls',
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      lspconfig.lua_ls.setup {}
      -- lspconfig.yamlls.setup {}

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show symbol documentation' })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[g]oto [d]efinition' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[c]ode [a]ctions' })
    end,
  },
}
