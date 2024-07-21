-- Really cool setup with git commit history grid
-- https://github.com/GustafB/dotfiles/blob/master/config/nvim/lua/cafebabe/lazy/dashboard.lua

-- Interesting example of a bulbasaur ascii art, but it's a picture
-- https://imgur.com/gallery/ascii-pokedex-generation-1-1-3-version-2-67uYiaQ

math.randomseed(os.time())

local colors = {
  green = 'String',
  blue = 'Function',
  peach = 'Identifier',
  purple = 'Keyword',
  cyan = 'Operator',
  pink = 'Special',
}
local icons = {
  ui = {
    file = '',
    files = '',
    open_folder = '',
    config = '',
    close = '󰈆',
    git = '',
    elipsis = '󰇘',
    lightning = '⚡',
    branch = '',
    tree = '󰙅',
  },
}

return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    vim.cmd 'rshada'
    local filtered_paths = {}

    for _, path in ipairs(vim.v.oldfiles) do
      if not path:match 'NvimTree_%d+$' then
        table.insert(filtered_paths, path)
      end
    end

    local base_directory = vim.fn.getcwd()
    local cwd_paths = {}
    local current_cwd_paths_amount = 0
    local desired_cwd_paths_amount = 5
    local global_paths = {}
    local current_global_paths_amount = 0
    local desired_global_paths_amount = 5

    local function remove_cwd(path)
      return path:gsub(base_directory .. '/', '')
    end

    local function shorten_home(path)
      return path:gsub(vim.env.HOME, '~')
    end

    -- sort paths into those in the current working directory and those not
    for _, path in ipairs(filtered_paths) do
      if string.find(path, base_directory, 1, true) then
        if current_cwd_paths_amount < desired_cwd_paths_amount then
          table.insert(cwd_paths, path)
          current_cwd_paths_amount = current_cwd_paths_amount + 1
        end
      else
        if current_global_paths_amount < desired_global_paths_amount then
          table.insert(global_paths, path)
          current_global_paths_amount = current_global_paths_amount + 1
        end
      end
    end

    -- truncate a path, rounding down to the nearest /
    local function truncate_path(path, max_length)
      if not max_length then
        max_length = 50
      end
      if #path <= max_length then
        return path
      end
      local truncated_path = path:sub(-max_length)
      local first_slash_pos = truncated_path:find '/'
      if first_slash_pos then
        truncated_path = truncated_path:sub(first_slash_pos)
      end
      return icons.ui.elipsis .. truncated_path
    end

    local function map_path_to_button(paths, keybind_offset, style_func)
      local buttons = {}
      for i, path in ipairs(paths) do
        local path_desc = path
        if style_func then
          path_desc = style_func(path)
        end
        table.insert(
          buttons,
          dashboard.button(tostring(i + keybind_offset - 1), icons.ui.file .. '  ' .. truncate_path(path_desc, 44), function()
            vim.cmd('e ' .. path)
          end)
        )
      end
      return buttons
    end

    local function get_git_repo()
      local result = vim.fn.system 'git remote get-url origin'
      if vim.v.shell_error ~= 0 then
        return ''
      end
      -- Extract the repo name from the URL
      local repo_name = result:match '.*/(.*).git'
      return icons.ui.git .. '  ' .. repo_name
    end

    local function get_git_branch()
      local result = vim.fn.system 'git branch --show-current'
      if vim.v.shell_error ~= 0 then
        return ''
      end
      return icons.ui.branch .. '  ' .. result:gsub('%s+', '')
    end

    local repo_name = get_git_repo()
    local branch_name = get_git_branch()

    local function pad(n)
      return { type = 'padding', val = n }
    end

    local function center_header(header)
      local lines = {}
      for line in string.gmatch(header, '[^\n]+') do
        table.insert(lines, line)
      end

      local width = vim.api.nvim_win_get_width(0) -- Get the width of the current window
      local padding = math.floor((width - #lines[1]) / 2) -- Calculate padding based on the first line length
      for i, line in ipairs(lines) do
        lines[i] = string.rep(' ', padding) .. line
      end
      return lines
    end

    local ascii_header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
    ]]

    local header = {
      type = 'text',
      val = center_header(ascii_header),
      opts = { hl = colors.blue },
    }

    local git_section = {
      type = 'text',
      val = repo_name .. '  ' .. branch_name,
      opts = { position = 'center', hl = colors.purple },
    }

    local cwd_section = {
      type = 'text',
      val = icons.ui.open_folder .. '  ' .. base_directory,
      opts = { position = 'center', hl = colors.pink },
    }

    local recent_cwd_files_section_header = {
      type = 'text',
      val = icons.ui.files .. '  Recent CWD Files                               ', -- these spaces are to aligh the text with section below
      opts = { position = 'center', hl = colors.green },
    }
    local recent_cwd_files_section = {
      type = 'group',
      val = map_path_to_button(cwd_paths, 0, remove_cwd),
      opts = {},
    }

    local recent_global_files_section_header = {
      type = 'text',
      val = icons.ui.files .. '  Recent Files                                   ', -- these spaces are to aligh the text with section below
      opts = { position = 'center', hl = colors.blue },
    }
    local recent_global_files_section = {
      type = 'group',
      val = map_path_to_button(global_paths, 5, shorten_home),
      opts = {},
    }

    local actions_section_header = {
      type = 'text',
      val = icons.ui.lightning .. ' Actions                                         ', -- these spaces are to aligh the text with section below
      opts = { position = 'center', hl = colors.purple },
    }
    local actions_section = {
      type = 'group',
      val = {
        dashboard.button('f', icons.ui.tree .. '  File Tree', '<cmd>NvimTreeToggle<CR>'),
        -- dashboard.button('e', icons.ui.file .. '  New file', '<cmd>new<CR>'),
        -- dashboard.button('r', icons.ui.files .. '  Recent Files', '<cmd>Telescope oldfiles<cr>'),
        -- dashboard.button('f', icons.ui.open_folder .. '  Explorer', '<cmd>Oil<cr>'),
        -- dashboard.button('c', icons.ui.config .. '  Neovim config', '<cmd>Oil /home/cafebabe/install/dotfiles/config/nvim<cr>'),
        -- dashboard.button('g', icons.ui.git .. '  Open Git', '<cmd>Neogit<CR>'),
        -- dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<cr>'),
        dashboard.button('q', icons.ui.close .. '  Quit NVIM', ':qa<CR>'),
      },
      opts = { position = 'center' },
    }

    -- Custom footer showing number of plugins loaded
    -- local footer = {
    --   type = 'text',
    --   val = { '⚡' .. require('lazy').stats().loaded .. ' plugins loaded.' },
    --   opts = { position = 'center', hl = 'Comment' },
    -- }

    -- Custom section with a personal greeting
    -- local bottom_section = {
    --   type = 'text',
    --   val = "Hi Tyrel, it's" .. os.date ' %H:%M' .. '. How are you doing today?',
    --   opts = { position = 'center' },
    -- }
    --

    -- Setting up the alpha layout
    alpha.setup {
      layout = {
        header,
        git_section,
        cwd_section,
        pad(1),
        recent_cwd_files_section_header,
        recent_cwd_files_section,
        pad(1),
        recent_global_files_section_header,
        recent_global_files_section,
        pad(1),
        actions_section_header,
        actions_section,
      },
    }

    -- vim.api.nvim_create_autocmd('User', {
    --   once = true,
    --   pattern = 'LazyVimStarted',
    --   desc = 'Open NvimTree after startup',
    --   callback = function()
    --     vim.cmd 'NvimTreeToggle'
    --     vim.cmd(vim.api.nvim_replace_termcodes('normal <C-h>', true, true, true))
    --   end,
    -- })

    -- these were to get statusline to not appear on alpha, but they're not working correctly
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'AlphaReady',
    --   desc = 'Disable status and tabline for alpha',
    --   callback = function()
    --     -- vim.go.laststatus = 0
    --     vim.opt.showtabline = 0
    --   end,
    -- })
    -- vim.api.nvim_create_autocmd('BufUnload', {
    --   buffer = 0,
    --   desc = 'Enable status and tabline after alpha',
    --   callback = function()
    --     -- vim.go.laststatus = 3
    --     vim.opt.showtabline = 1
    --   end,
    -- })
  end,
}
