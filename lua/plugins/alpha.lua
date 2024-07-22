-- Really cool setup with git commit history grid
-- https://github.com/GustafB/dotfiles/blob/master/config/nvim/lua/cafebabe/lazy/dashboard.lua

-- Interesting example of a bulbasaur ascii art, but it's a picture
-- https://imgur.com/gallery/ascii-pokedex-generation-1-1-3-version-2-67uYiaQ

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
    lazy = '󰒲',
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

    -- v RECENT FILES v --

    -- this line gets vim.v.oldfiles to be populated sooner during initial load so that it can be accessed below
    vim.cmd 'rshada'
    local base_directory = vim.fn.getcwd()

    -- functions used to style paths for buttons
    local function remove_cwd(path)
      return path:gsub(base_directory .. '/', '')
    end
    local function shorten_home(path)
      return path:gsub(vim.env.HOME, '~')
    end
    local filtered_paths = {}

    -- filter out buffers belonging to NvimTree
    for _, path in ipairs(vim.v.oldfiles) do
      if not path:match 'NvimTree_%d+$' then
        table.insert(filtered_paths, path)
      end
    end

    -- sort paths into those in the current working directory and those not
    local desired_cwd_paths_amount = 5
    local desired_global_paths_amount = 5
    local cwd_paths = {}
    local current_cwd_paths_amount = 0
    local global_paths = {}
    local current_global_paths_amount = 0
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

    -- map a list of paths to alpha buttons
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

    -- ^ RECENT FILES ^ --
    -- v     GIT      v --

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

    -- ^      GIT     ^ --
    -- v    LAYOUT    v --

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

    -- ^    LAYOUT    ^ --
    -- v   SECTIONS   v --

    local header = {
      type = 'text',
      val = center_header(ascii_header),
      opts = { hl = colors.blue },
    }

    local git_section = {
      type = 'text',
      val = get_git_repo() .. '  ' .. get_git_branch(),
      opts = { position = 'center', hl = colors.purple },
    }

    local cwd_section = {
      type = 'text',
      val = icons.ui.open_folder .. '  ' .. shorten_home(base_directory),
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
      val = icons.ui.lightning .. ' Actions                                        ', -- these spaces are to aligh the text with section below
      opts = { position = 'center', hl = colors.purple },
    }
    local actions_section = {
      type = 'group',
      val = {
        dashboard.button('f', icons.ui.tree .. '  File Tree', '<cmd>NvimTreeToggle<CR>'),
        dashboard.button('l', icons.ui.lazy .. '  Lazy', '<cmd>Lazy<cr>'),
        dashboard.button('q', icons.ui.close .. '  Quit NVIM', ':qa<CR>'),
      },
      opts = { position = 'center' },
    }

    -- ^   SECTIONS   ^ --

    alpha.setup {
      layout = {
        pad(2),
        header,
        pad(1),
        git_section,
        cwd_section,
        pad(2),
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
  end,
}
