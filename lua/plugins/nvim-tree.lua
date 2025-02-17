-- file managing , picker etc
-- https://github.com/nvim-tree/nvim-tree.lua

-- Toggle NvimTree on boot
-- vim.api.nvim_create_autocmd('VimEnter', {
--   callback = function()
--     vim.cmd 'NvimTreeToggle'
--   end,
-- })
--

-- set pane width based on window width on startup
local window_width = vim.api.nvim_win_get_width(0)
local file_pane_width = math.floor(window_width * 0.25)

vim.keymap.set('n', '<leader>tf', '<cmd> NvimTreeToggle <CR>', { desc = '[T]oggle [F]ile Tree' })

return {
  'nvim-tree/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  opts = {
    filters = {
      dotfiles = false,
      exclude = { vim.fn.stdpath 'config' .. '/lua/custom' },
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    view = {
      adaptive_size = false,
      side = 'right',
      width = file_pane_width,
      preserve_window_proportions = true,
    },
    git = {
      enable = false,
      ignore = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    renderer = {
      root_folder_label = false,
      highlight_git = false,
      highlight_opened_files = 'none',

      indent_markers = {
        enable = false,
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = false,
        },

        glyphs = {
          default = '󰈚',
          symlink = '',
          folder = {
            default = '',
            empty = '',
            empty_open = '',
            open = '',
            symlink = '',
            symlink_open = '',
            arrow_open = '',
            arrow_closed = '',
          },
          git = {
            unstaged = '✗',
            staged = '✓',
            unmerged = '',
            renamed = '➜',
            untracked = '★',
            deleted = '',
            ignored = '◌',
          },
        },
      },
    },
  },
  -- config = function(_, opts)
  --   dofile(vim.g.base46_cache .. 'nvimtree')
  --   require('nvim-tree').setup(opts)
  -- end,
}
