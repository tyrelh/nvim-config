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
          'bashls',
          'gopls',
          'groovyls',
          'lua_ls',
          'pylsp',
          'tsserver',
          'yamlls',
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      lspconfig.bashls.setup {}
      lspconfig.gopls.setup {}
      lspconfig.groovyls.setup {
        cmd = {
          'java',
          '-jar',
          '/Users/tyrel/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar',
        },
      }
      lspconfig.lua_ls.setup {}
      lspconfig.pylsp.setup {
        settings = {
          pylsp = {
            plugins = {
              -- formatter options
              black = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              -- linter options
              pylint = { enabled = false, executable = 'pylint' },
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              -- type checker
              pylsp_mypy = { enabled = true },
              -- auto-completion options
              jedi_completion = { fuzzy = true },
              -- import sorting
              pyls_isort = { enabled = true },
            },
          },
        },
      }
      lspconfig.tsserver.setup {}
      lspconfig.yamlls.setup {
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
        settings = {
          yaml = {
            schemas = {
              ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            },
            -- CloudFormation
            customTags = {
              '!FindInMap',
              '!FindInMap sequence',
              '!GetAtt',
              '!GetAtt sequence',
              '!ImportValue',
              '!ImportValue sequence',
              '!Join',
              '!Join sequence',
              '!Ref',
              '!Ref sequence',
              '!Select',
              '!Select sequence',
              '!Split',
              '!Split sequence',
              '!Sub',
              '!Sub sequence',
              '!Equals',
              '!Equals sequence',
              '!Not',
              '!Not sequence',
            },
          },
        },
      }

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show symbol documentation' })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[g]oto [d]efinition' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[c]ode [a]ctions' })
    end,
  },
}
