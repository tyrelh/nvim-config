vim.keymap.set('n', 'f', '<cmd>Neotree position=right<cr>', { desc = 'Toggle [F]iletree' })

local WIDTH_PERCENTAGE = 0.25
local terminal_width = vim.api.nvim_win_get_width(0)
local file_pane_width = math.floor(terminal_width * WIDTH_PERCENTAGE)

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    window = {
      width = file_pane_width,
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          '.git',
          '.DS_Store',
        },
        always_show = {
          '.env',
        },
      },
    },
    hijack_netrw_behavior = 'open_default',
  },
}
