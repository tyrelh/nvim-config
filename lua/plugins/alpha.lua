-- Really cool setup with git commit history grid
-- https://github.com/GustafB/dotfiles/blob/master/config/nvim/lua/cafebabe/lazy/dashboard.lua

math.randomseed(os.time())

local function pick_color()
  local colors = {
    'String', -- green
    -- 'Comment', -- grey
    'Function', -- blue`
    'Identifier', -- light peach
    'Keyword', -- purple
    -- 'Number', -- orange
    'Operator', -- cyan
    'PreProc', -- pink
    'Special', -- pink
    'Statement', -- purple
    -- 'Type', -- yellow
    -- 'Underlined', -- literally underlined
  }
  return colors[math.random(#colors)]
end

return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-tree/nvim-tree.lua', -- NOTE: see note below
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.startify'

    local c = pick_color()
    dashboard.section.header.opts.hl = c
    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      -- c,
    }

    alpha.setup(dashboard.opts)

    -- TODO: the below comments disable and enable status and tabline. I'd like to do something similar for my tabs and lualine
    --
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'AlphaReady',
    --   desc = 'Disable status and tabline for alpha',
    --   callback = function()
    --     vim.go.laststatus = 0
    --     vim.opt.showtabline = 0
    --   end,
    -- })
    -- vim.api.nvim_create_autocmd('BufUnload', {
    --   buffer = 0,
    --   desc = 'Enable status and tabline after alpha',
    --   callback = function()
    --     vim.go.laststatus = 3
    --     vim.opt.showtabline = 2
    --   end,
    -- })

    -- NOTE: This gets nvim-tree to open on startup, and thus is an implicit dependency
    vim.api.nvim_create_autocmd('User', {
      once = true,
      pattern = 'LazyVimStarted',
      callback = function()
        -- local stats = require('lazy').stats()
        -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        -- dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
        -- pcall(vim.cmd.AlphaRedraw)

        vim.cmd 'NvimTreeToggle'
      end,
    })
  end,
}
