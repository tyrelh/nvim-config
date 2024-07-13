return {
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- https://github.com/catppuccin/nvim
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'auto', -- latte, frappe, macchiato, mocha
      transparent_background = true,
      integrations = {
        telescope = {
          enabled = true,
          style = 'nvchad',
        },
        which_key = true,
      },
    },
    init = function()
      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- https://github.com/f-person/auto-dark-mode.nvim
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 500,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
        -- vim.cmd("colorscheme gruvbox")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
        -- vim.cmd("colorscheme gruvbox")
      end,
    },
  },
}
