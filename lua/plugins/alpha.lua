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
    lightning = '󱐋',
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

    -- filter out junk paths
    local filters = {
      'NvimTree_%d+$',
      '^.*neo%-tree filesystem %[%d%]$',
      '^term:%/%/.*',
    }
    local filtered_paths = {}
    for _, path in ipairs(vim.v.oldfiles) do
      local should_filter = false
      for _, filter in ipairs(filters) do
        if path:match(filter) then
          should_filter = true
          break
        end
      end
      if not should_filter then
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

    vim.api.nvim_set_hl(0, 'I2A0', { fg = '#010101' })
    vim.api.nvim_set_hl(0, 'I2A1', { fg = '#3e5622' })
    vim.api.nvim_set_hl(0, 'I2A2', { fg = '#7cab43' })
    vim.api.nvim_set_hl(0, 'I2A3', { fg = '#5a7040' })
    vim.api.nvim_set_hl(0, 'I2A4', { fg = '#57772f' })
    vim.api.nvim_set_hl(0, 'I2A5', { fg = '#89be49' })
    vim.api.nvim_set_hl(0, 'I2A6', { fg = '#96d14f' })
    vim.api.nvim_set_hl(0, 'I2A7', { fg = '#78a047' })
    vim.api.nvim_set_hl(0, 'I2A8', { fg = '#84b34a' })
    vim.api.nvim_set_hl(0, 'I2A9', { fg = '#425a25' })
    vim.api.nvim_set_hl(0, 'I2A10', { fg = '#000000' })
    vim.api.nvim_set_hl(0, 'I2A11', { fg = '#96d05a' })
    vim.api.nvim_set_hl(0, 'I2A12', { fg = '#b1f571' })
    vim.api.nvim_set_hl(0, 'I2A13', { fg = '#a3e360' })
    vim.api.nvim_set_hl(0, 'I2A14', { fg = '#6b8d41' })
    vim.api.nvim_set_hl(0, 'I2A15', { fg = '#3e5521' })
    vim.api.nvim_set_hl(0, 'I2A16', { fg = '#2d4a4f' })
    vim.api.nvim_set_hl(0, 'I2A17', { fg = '#5a939e' })
    vim.api.nvim_set_hl(0, 'I2A18', { fg = '#2c5568' })
    vim.api.nvim_set_hl(0, 'I2A19', { fg = '#162b34' })
    vim.api.nvim_set_hl(0, 'I2A20', { fg = '#2d3820' })
    vim.api.nvim_set_hl(0, 'I2A21', { fg = '#61935b' })
    vim.api.nvim_set_hl(0, 'I2A22', { fg = '#62bba8' })
    vim.api.nvim_set_hl(0, 'I2A23', { fg = '#6be3b3' })
    vim.api.nvim_set_hl(0, 'I2A24', { fg = '#63d9a7' })
    vim.api.nvim_set_hl(0, 'I2A25', { fg = '#5ccf9b' })
    vim.api.nvim_set_hl(0, 'I2A26', { fg = '#5bb19c' })
    vim.api.nvim_set_hl(0, 'I2A27', { fg = '#449281' })
    vim.api.nvim_set_hl(0, 'I2A28', { fg = '#4b9c8d' })
    vim.api.nvim_set_hl(0, 'I2A29', { fg = '#2d494f' })
    vim.api.nvim_set_hl(0, 'I2A30', { fg = '#5bb79c' })
    vim.api.nvim_set_hl(0, 'I2A31', { fg = '#63cda7' })
    vim.api.nvim_set_hl(0, 'I2A32', { fg = '#61b2a6' })
    vim.api.nvim_set_hl(0, 'I2A33', { fg = '#5bbd9c' })
    vim.api.nvim_set_hl(0, 'I2A34', { fg = '#5baa9d' })
    vim.api.nvim_set_hl(0, 'I2A35', { fg = '#86ba48' })
    vim.api.nvim_set_hl(0, 'I2A36', { fg = '#81b245' })
    vim.api.nvim_set_hl(0, 'I2A37', { fg = '#232c19' })
    vim.api.nvim_set_hl(0, 'I2A38', { fg = '#437483' })
    vim.api.nvim_set_hl(0, 'I2A39', { fg = '#9ab7bc' })
    vim.api.nvim_set_hl(0, 'I2A40', { fg = '#dbdbdb' })
    vim.api.nvim_set_hl(0, 'I2A41', { fg = '#8398a1' })
    vim.api.nvim_set_hl(0, 'I2A42', { fg = '#2e4a50' })
    vim.api.nvim_set_hl(0, 'I2A43', { fg = '#ffffff' })
    vim.api.nvim_set_hl(0, 'I2A44', { fg = '#dc9395' })
    vim.api.nvim_set_hl(0, 'I2A45', { fg = '#b9272a' })
    vim.api.nvim_set_hl(0, 'I2A46', { fg = '#63bba9' })
    vim.api.nvim_set_hl(0, 'I2A47', { fg = '#64d9a7' })
    vim.api.nvim_set_hl(0, 'I2A48', { fg = '#2e684e' })
    vim.api.nvim_set_hl(0, 'I2A49', { fg = '#5d1415' })
    vim.api.nvim_set_hl(0, 'I2A50', { fg = '#ededed' })
    vim.api.nvim_set_hl(0, 'I2A51', { fg = '#6e6e6e' })
    vim.api.nvim_set_hl(0, 'I2A52', { fg = '#548b97' })
    vim.api.nvim_set_hl(0, 'I2A53', { fg = '#5fb7a5' })
    vim.api.nvim_set_hl(0, 'I2A54', { fg = '#e9f1f2' })
    vim.api.nvim_set_hl(0, 'I2A55', { fg = '#f3aeab' })
    vim.api.nvim_set_hl(0, 'I2A56', { fg = '#fc6b64' })
    vim.api.nvim_set_hl(0, 'I2A57', { fg = '#61baa7' })
    vim.api.nvim_set_hl(0, 'I2A58', { fg = '#69e0b0' })
    vim.api.nvim_set_hl(0, 'I2A59', { fg = '#62d7a5' })
    vim.api.nvim_set_hl(0, 'I2A60', { fg = '#acc9ce' })
    vim.api.nvim_set_hl(0, 'I2A61', { fg = '#843f3c' })
    vim.api.nvim_set_hl(0, 'I2A62', { fg = '#0c1315' })
    vim.api.nvim_set_hl(0, 'I2A63', { fg = '#869ca5' })
    vim.api.nvim_set_hl(0, 'I2A64', { fg = '#325d6f' })
    vim.api.nvim_set_hl(0, 'I2A65', { fg = '#060b0e' })
    vim.api.nvim_set_hl(0, 'I2A66', { fg = '#304f56' })
    vim.api.nvim_set_hl(0, 'I2A67', { fg = '#40707f' })
    vim.api.nvim_set_hl(0, 'I2A68', { fg = '#546c45' })
    vim.api.nvim_set_hl(0, 'I2A69', { fg = '#51673e' })
    vim.api.nvim_set_hl(0, 'I2A70', { fg = '#4e6138' })
    vim.api.nvim_set_hl(0, 'I2A71', { fg = '#27311c' })
    vim.api.nvim_set_hl(0, 'I2A72', { fg = '#162a34' })
    vim.api.nvim_set_hl(0, 'I2A73', { fg = '#2b464c' })
    vim.api.nvim_set_hl(0, 'I2A74', { fg = '#6a968b' })
    vim.api.nvim_set_hl(0, 'I2A75', { fg = '#aae6cb' })
    vim.api.nvim_set_hl(0, 'I2A76', { fg = '#8c5b61' })
    vim.api.nvim_set_hl(0, 'I2A77', { fg = '#8c6961' })
    vim.api.nvim_set_hl(0, 'I2A78', { fg = '#8c7760' })
    vim.api.nvim_set_hl(0, 'I2A79', { fg = '#a24146' })
    vim.api.nvim_set_hl(0, 'I2A80', { fg = '#da8e90' })
    vim.api.nvim_set_hl(0, 'I2A81', { fg = '#a8666c' })
    vim.api.nvim_set_hl(0, 'I2A82', { fg = '#763d47' })
    vim.api.nvim_set_hl(0, 'I2A83', { fg = '#514958' })
    vim.api.nvim_set_hl(0, 'I2A84', { fg = '#386576' })
    vim.api.nvim_set_hl(0, 'I2A85', { fg = '#447584' })
    vim.api.nvim_set_hl(0, 'I2A86', { fg = '#4e8390' })
    vim.api.nvim_set_hl(0, 'I2A87', { fg = '#427382' })
    vim.api.nvim_set_hl(0, 'I2A88', { fg = '#4f8491' })
    vim.api.nvim_set_hl(0, 'I2A89', { fg = '#8a7b62' })
    vim.api.nvim_set_hl(0, 'I2A90', { fg = '#243a3e' })
    vim.api.nvim_set_hl(0, 'I2A91', { fg = '#46737c' })
    vim.api.nvim_set_hl(0, 'I2A92', { fg = '#5cc29c' })
    vim.api.nvim_set_hl(0, 'I2A93', { fg = '#5aa09d' })
    vim.api.nvim_set_hl(0, 'I2A94', { fg = '#366f73' })
    vim.api.nvim_set_hl(0, 'I2A95', { fg = '#538d7b' })
    vim.api.nvim_set_hl(0, 'I2A96', { fg = '#70aa82' })
    vim.api.nvim_set_hl(0, 'I2A97', { fg = '#7fb98f' })
    vim.api.nvim_set_hl(0, 'I2A98', { fg = '#77b289' })
    vim.api.nvim_set_hl(0, 'I2A99', { fg = '#487b89' })
    vim.api.nvim_set_hl(0, 'I2A100', { fg = '#366274' })
    vim.api.nvim_set_hl(0, 'I2A101', { fg = '#67d1ae' })
    vim.api.nvim_set_hl(0, 'I2A102', { fg = '#69dab1' })
    vim.api.nvim_set_hl(0, 'I2A103', { fg = '#5da4a2' })
    vim.api.nvim_set_hl(0, 'I2A104', { fg = '#4a838b' })
    vim.api.nvim_set_hl(0, 'I2A105', { fg = '#0a1217' })
    vim.api.nvim_set_hl(0, 'I2A106', { fg = '#508592' })
    vim.api.nvim_set_hl(0, 'I2A107', { fg = '#558c98' })
    vim.api.nvim_set_hl(0, 'I2A108', { fg = '#32535a' })
    vim.api.nvim_set_hl(0, 'I2A109', { fg = '#050708' })
    vim.api.nvim_set_hl(0, 'I2A110', { fg = '#182e38' })
    vim.api.nvim_set_hl(0, 'I2A111', { fg = '#2e5a6a' })
    vim.api.nvim_set_hl(0, 'I2A112', { fg = '#459482' })
    vim.api.nvim_set_hl(0, 'I2A113', { fg = '#5ccc9b' })
    vim.api.nvim_set_hl(0, 'I2A114', { fg = '#5bb09c' })
    vim.api.nvim_set_hl(0, 'I2A115', { fg = '#58909c' })
    vim.api.nvim_set_hl(0, 'I2A116', { fg = '#6adfb2' })
    vim.api.nvim_set_hl(0, 'I2A117', { fg = '#6be1b2' })
    vim.api.nvim_set_hl(0, 'I2A118', { fg = '#59929d' })
    vim.api.nvim_set_hl(0, 'I2A119', { fg = '#2c484e' })
    vim.api.nvim_set_hl(0, 'I2A120', { fg = '#357159' })
    vim.api.nvim_set_hl(0, 'I2A121', { fg = '#1a2a2d' })
    vim.api.nvim_set_hl(0, 'I2A122', { fg = '#33535a' })
    vim.api.nvim_set_hl(0, 'I2A123', { fg = '#284045' })
    vim.api.nvim_set_hl(0, 'I2A124', { fg = '#203840' })
    vim.api.nvim_set_hl(0, 'I2A125', { fg = '#19303b' })
    vim.api.nvim_set_hl(0, 'I2A126', { fg = '#142023' })
    vim.api.nvim_set_hl(0, 'I2A127', { fg = '#14252e' })
    vim.api.nvim_set_hl(0, 'I2A128', { fg = '#0d191e' })
    vim.api.nvim_set_hl(0, 'I2A129', { fg = '#0d181e' })
    local bulbasaur_hl = {
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A0', 12, 15 },
        { 'I2A0', 15, 18 },
        { 'I2A0', 18, 21 },
        { 'I2A0', 21, 24 },
        { 'I2A0', 24, 27 },
        { 'I2A0', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A0', 51, 54 },
        { 'I2A0', 54, 57 },
        { 'I2A0', 57, 60 },
        { 'I2A0', 60, 63 },
        { 'I2A0', 63, 66 },
        { 'I2A0', 66, 69 },
        { 'I2A0', 69, 72 },
        { 'I2A0', 72, 75 },
        { 'I2A0', 75, 78 },
        { 'I2A0', 78, 81 },
        { 'I2A0', 81, 84 },
        { 'I2A0', 84, 87 },
        { 'I2A0', 87, 90 },
        { 'I2A0', 90, 93 },
        { 'I2A0', 93, 96 },
        { 'I2A0', 96, 99 },
        { 'I2A1', 99, 102 },
        { 'I2A2', 102, 105 },
        { 'I2A0', 105, 108 },
        { 'I2A3', 108, 111 },
        { 'I2A3', 111, 114 },
        { 'I2A3', 114, 117 },
        { 'I2A0', 117, 120 },
        { 'I2A0', 120, 123 },
        { 'I2A0', 123, 126 },
        { 'I2A0', 126, 129 },
        { 'I2A0', 129, 132 },
        { 'I2A0', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A0', 12, 15 },
        { 'I2A0', 15, 18 },
        { 'I2A0', 18, 21 },
        { 'I2A0', 21, 24 },
        { 'I2A0', 24, 27 },
        { 'I2A0', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A0', 51, 54 },
        { 'I2A0', 54, 57 },
        { 'I2A0', 57, 60 },
        { 'I2A0', 60, 63 },
        { 'I2A0', 63, 66 },
        { 'I2A0', 66, 69 },
        { 'I2A0', 69, 72 },
        { 'I2A0', 72, 75 },
        { 'I2A0', 75, 78 },
        { 'I2A0', 78, 81 },
        { 'I2A0', 81, 84 },
        { 'I2A0', 84, 87 },
        { 'I2A4', 87, 90 },
        { 'I2A4', 90, 93 },
        { 'I2A4', 93, 96 },
        { 'I2A2', 96, 99 },
        { 'I2A5', 99, 102 },
        { 'I2A6', 102, 105 },
        { 'I2A2', 105, 108 },
        { 'I2A3', 108, 111 },
        { 'I2A7', 111, 114 },
        { 'I2A6', 114, 117 },
        { 'I2A8', 117, 120 },
        { 'I2A9', 120, 123 },
        { 'I2A10', 123, 126 },
        { 'I2A0', 126, 129 },
        { 'I2A0', 129, 132 },
        { 'I2A0', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A0', 12, 15 },
        { 'I2A0', 15, 18 },
        { 'I2A0', 18, 21 },
        { 'I2A0', 21, 24 },
        { 'I2A0', 24, 27 },
        { 'I2A0', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A0', 51, 54 },
        { 'I2A0', 54, 57 },
        { 'I2A0', 57, 60 },
        { 'I2A0', 60, 63 },
        { 'I2A0', 63, 66 },
        { 'I2A0', 66, 69 },
        { 'I2A1', 69, 72 },
        { 'I2A2', 72, 75 },
        { 'I2A2', 75, 78 },
        { 'I2A2', 78, 81 },
        { 'I2A11', 81, 84 },
        { 'I2A12', 84, 87 },
        { 'I2A12', 87, 90 },
        { 'I2A12', 90, 93 },
        { 'I2A12', 93, 96 },
        { 'I2A12', 96, 99 },
        { 'I2A13', 99, 102 },
        { 'I2A6', 102, 105 },
        { 'I2A3', 105, 108 },
        { 'I2A6', 108, 111 },
        { 'I2A6', 111, 114 },
        { 'I2A6', 114, 117 },
        { 'I2A6', 117, 120 },
        { 'I2A7', 120, 123 },
        { 'I2A3', 123, 126 },
        { 'I2A10', 126, 129 },
        { 'I2A10', 129, 132 },
        { 'I2A10', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A0', 12, 15 },
        { 'I2A0', 15, 18 },
        { 'I2A0', 18, 21 },
        { 'I2A0', 21, 24 },
        { 'I2A0', 24, 27 },
        { 'I2A0', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A0', 51, 54 },
        { 'I2A0', 54, 57 },
        { 'I2A0', 57, 60 },
        { 'I2A1', 60, 63 },
        { 'I2A2', 63, 66 },
        { 'I2A6', 66, 69 },
        { 'I2A6', 69, 72 },
        { 'I2A13', 72, 75 },
        { 'I2A12', 75, 78 },
        { 'I2A12', 78, 81 },
        { 'I2A12', 81, 84 },
        { 'I2A12', 84, 87 },
        { 'I2A6', 87, 90 },
        { 'I2A6', 90, 93 },
        { 'I2A6', 93, 96 },
        { 'I2A6', 96, 99 },
        { 'I2A7', 99, 102 },
        { 'I2A3', 102, 105 },
        { 'I2A6', 105, 108 },
        { 'I2A12', 108, 111 },
        { 'I2A13', 111, 114 },
        { 'I2A6', 114, 117 },
        { 'I2A2', 117, 120 },
        { 'I2A14', 120, 123 },
        { 'I2A3', 123, 126 },
        { 'I2A2', 126, 129 },
        { 'I2A15', 129, 132 },
        { 'I2A10', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A0', 12, 15 },
        { 'I2A0', 15, 18 },
        { 'I2A0', 18, 21 },
        { 'I2A0', 21, 24 },
        { 'I2A0', 24, 27 },
        { 'I2A0', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A1', 51, 54 },
        { 'I2A2', 54, 57 },
        { 'I2A6', 57, 60 },
        { 'I2A6', 60, 63 },
        { 'I2A6', 63, 66 },
        { 'I2A6', 66, 69 },
        { 'I2A6', 69, 72 },
        { 'I2A7', 72, 75 },
        { 'I2A3', 75, 78 },
        { 'I2A6', 78, 81 },
        { 'I2A6', 81, 84 },
        { 'I2A6', 84, 87 },
        { 'I2A6', 87, 90 },
        { 'I2A13', 90, 93 },
        { 'I2A12', 93, 96 },
        { 'I2A12', 96, 99 },
        { 'I2A12', 99, 102 },
        { 'I2A12', 102, 105 },
        { 'I2A6', 105, 108 },
        { 'I2A12', 108, 111 },
        { 'I2A13', 111, 114 },
        { 'I2A6', 114, 117 },
        { 'I2A6', 117, 120 },
        { 'I2A7', 120, 123 },
        { 'I2A3', 123, 126 },
        { 'I2A2', 126, 129 },
        { 'I2A14', 129, 132 },
        { 'I2A3', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A16', 12, 15 },
        { 'I2A17', 15, 18 },
        { 'I2A18', 18, 21 },
        { 'I2A19', 21, 24 },
        { 'I2A0', 24, 27 },
        { 'I2A0', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A20', 51, 54 },
        { 'I2A3', 54, 57 },
        { 'I2A6', 57, 60 },
        { 'I2A6', 60, 63 },
        { 'I2A6', 63, 66 },
        { 'I2A6', 66, 69 },
        { 'I2A5', 69, 72 },
        { 'I2A5', 72, 75 },
        { 'I2A6', 75, 78 },
        { 'I2A18', 78, 81 },
        { 'I2A18', 81, 84 },
        { 'I2A18', 84, 87 },
        { 'I2A18', 87, 90 },
        { 'I2A21', 90, 93 },
        { 'I2A6', 93, 96 },
        { 'I2A12', 96, 99 },
        { 'I2A13', 99, 102 },
        { 'I2A6', 102, 105 },
        { 'I2A12', 105, 108 },
        { 'I2A6', 108, 111 },
        { 'I2A13', 111, 114 },
        { 'I2A12', 114, 117 },
        { 'I2A6', 117, 120 },
        { 'I2A7', 120, 123 },
        { 'I2A3', 123, 126 },
        { 'I2A2', 126, 129 },
        { 'I2A14', 129, 132 },
        { 'I2A3', 132, 135 },
        { 'I2A10', 135, 138 },
        { 'I2A10', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A17', 9, 12 },
        { 'I2A22', 12, 15 },
        { 'I2A23', 15, 18 },
        { 'I2A23', 18, 21 },
        { 'I2A24', 21, 24 },
        { 'I2A25', 24, 27 },
        { 'I2A17', 27, 30 },
        { 'I2A26', 30, 33 },
        { 'I2A25', 33, 36 },
        { 'I2A25', 36, 39 },
        { 'I2A25', 39, 42 },
        { 'I2A25', 42, 45 },
        { 'I2A25', 45, 48 },
        { 'I2A25', 48, 51 },
        { 'I2A25', 51, 54 },
        { 'I2A25', 54, 57 },
        { 'I2A25', 57, 60 },
        { 'I2A27', 60, 63 },
        { 'I2A18', 63, 66 },
        { 'I2A18', 66, 69 },
        { 'I2A28', 69, 72 },
        { 'I2A23', 72, 75 },
        { 'I2A23', 75, 78 },
        { 'I2A25', 78, 81 },
        { 'I2A25', 81, 84 },
        { 'I2A25', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A29', 90, 93 },
        { 'I2A10', 93, 96 },
        { 'I2A6', 96, 99 },
        { 'I2A6', 99, 102 },
        { 'I2A6', 102, 105 },
        { 'I2A6', 105, 108 },
        { 'I2A6', 108, 111 },
        { 'I2A6', 111, 114 },
        { 'I2A6', 114, 117 },
        { 'I2A2', 117, 120 },
        { 'I2A14', 120, 123 },
        { 'I2A3', 123, 126 },
        { 'I2A2', 126, 129 },
        { 'I2A2', 129, 132 },
        { 'I2A2', 132, 135 },
        { 'I2A2', 135, 138 },
        { 'I2A15', 138, 141 },
        { 'I2A10', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A17', 9, 12 },
        { 'I2A22', 12, 15 },
        { 'I2A23', 15, 18 },
        { 'I2A23', 18, 21 },
        { 'I2A23', 21, 24 },
        { 'I2A23', 24, 27 },
        { 'I2A25', 27, 30 },
        { 'I2A25', 30, 33 },
        { 'I2A25', 33, 36 },
        { 'I2A17', 36, 39 },
        { 'I2A17', 39, 42 },
        { 'I2A17', 42, 45 },
        { 'I2A17', 45, 48 },
        { 'I2A17', 48, 51 },
        { 'I2A26', 51, 54 },
        { 'I2A25', 54, 57 },
        { 'I2A25', 57, 60 },
        { 'I2A25', 60, 63 },
        { 'I2A25', 63, 66 },
        { 'I2A25', 66, 69 },
        { 'I2A25', 69, 72 },
        { 'I2A25', 72, 75 },
        { 'I2A25', 75, 78 },
        { 'I2A25', 78, 81 },
        { 'I2A26', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A29', 90, 93 },
        { 'I2A10', 93, 96 },
        { 'I2A6', 96, 99 },
        { 'I2A6', 99, 102 },
        { 'I2A6', 102, 105 },
        { 'I2A6', 105, 108 },
        { 'I2A6', 108, 111 },
        { 'I2A6', 111, 114 },
        { 'I2A6', 114, 117 },
        { 'I2A2', 117, 120 },
        { 'I2A2', 120, 123 },
        { 'I2A2', 123, 126 },
        { 'I2A3', 126, 129 },
        { 'I2A14', 129, 132 },
        { 'I2A2', 132, 135 },
        { 'I2A2', 135, 138 },
        { 'I2A15', 138, 141 },
        { 'I2A10', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A30', 9, 12 },
        { 'I2A31', 12, 15 },
        { 'I2A23', 15, 18 },
        { 'I2A23', 18, 21 },
        { 'I2A23', 21, 24 },
        { 'I2A23', 24, 27 },
        { 'I2A32', 27, 30 },
        { 'I2A32', 30, 33 },
        { 'I2A32', 33, 36 },
        { 'I2A23', 36, 39 },
        { 'I2A30', 39, 42 },
        { 'I2A30', 42, 45 },
        { 'I2A30', 45, 48 },
        { 'I2A25', 48, 51 },
        { 'I2A25', 51, 54 },
        { 'I2A25', 54, 57 },
        { 'I2A25', 57, 60 },
        { 'I2A25', 60, 63 },
        { 'I2A25', 63, 66 },
        { 'I2A25', 66, 69 },
        { 'I2A25', 69, 72 },
        { 'I2A33', 72, 75 },
        { 'I2A34', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A29', 90, 93 },
        { 'I2A10', 93, 96 },
        { 'I2A35', 96, 99 },
        { 'I2A35', 99, 102 },
        { 'I2A35', 102, 105 },
        { 'I2A35', 105, 108 },
        { 'I2A35', 108, 111 },
        { 'I2A36', 111, 114 },
        { 'I2A2', 114, 117 },
        { 'I2A2', 117, 120 },
        { 'I2A2', 120, 123 },
        { 'I2A2', 123, 126 },
        { 'I2A3', 126, 129 },
        { 'I2A14', 129, 132 },
        { 'I2A2', 132, 135 },
        { 'I2A2', 135, 138 },
        { 'I2A2', 138, 141 },
        { 'I2A2', 141, 144 },
        { 'I2A37', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A16', 3, 6 },
        { 'I2A17', 6, 9 },
        { 'I2A23', 9, 12 },
        { 'I2A23', 12, 15 },
        { 'I2A23', 15, 18 },
        { 'I2A23', 18, 21 },
        { 'I2A23', 21, 24 },
        { 'I2A23', 24, 27 },
        { 'I2A17', 27, 30 },
        { 'I2A17', 30, 33 },
        { 'I2A17', 33, 36 },
        { 'I2A23', 36, 39 },
        { 'I2A25', 39, 42 },
        { 'I2A25', 42, 45 },
        { 'I2A25', 45, 48 },
        { 'I2A17', 48, 51 },
        { 'I2A22', 51, 54 },
        { 'I2A23', 54, 57 },
        { 'I2A23', 57, 60 },
        { 'I2A22', 60, 63 },
        { 'I2A17', 63, 66 },
        { 'I2A18', 66, 69 },
        { 'I2A27', 69, 72 },
        { 'I2A26', 72, 75 },
        { 'I2A17', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A38', 90, 93 },
        { 'I2A18', 93, 96 },
        { 'I2A10', 96, 99 },
        { 'I2A15', 99, 102 },
        { 'I2A2', 102, 105 },
        { 'I2A2', 105, 108 },
        { 'I2A2', 108, 111 },
        { 'I2A2', 111, 114 },
        { 'I2A2', 114, 117 },
        { 'I2A2', 117, 120 },
        { 'I2A2', 120, 123 },
        { 'I2A2', 123, 126 },
        { 'I2A3', 126, 129 },
        { 'I2A14', 129, 132 },
        { 'I2A2', 132, 135 },
        { 'I2A2', 135, 138 },
        { 'I2A2', 138, 141 },
        { 'I2A2', 141, 144 },
        { 'I2A10', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A16', 3, 6 },
        { 'I2A17', 6, 9 },
        { 'I2A23', 9, 12 },
        { 'I2A22', 12, 15 },
        { 'I2A17', 15, 18 },
        { 'I2A23', 18, 21 },
        { 'I2A23', 21, 24 },
        { 'I2A23', 24, 27 },
        { 'I2A23', 27, 30 },
        { 'I2A23', 30, 33 },
        { 'I2A23', 33, 36 },
        { 'I2A23', 36, 39 },
        { 'I2A25', 39, 42 },
        { 'I2A26', 42, 45 },
        { 'I2A17', 45, 48 },
        { 'I2A23', 48, 51 },
        { 'I2A23', 51, 54 },
        { 'I2A23', 54, 57 },
        { 'I2A17', 57, 60 },
        { 'I2A39', 60, 63 },
        { 'I2A40', 63, 66 },
        { 'I2A40', 66, 69 },
        { 'I2A41', 69, 72 },
        { 'I2A38', 72, 75 },
        { 'I2A17', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A10', 96, 99 },
        { 'I2A10', 99, 102 },
        { 'I2A10', 102, 105 },
        { 'I2A2', 105, 108 },
        { 'I2A2', 108, 111 },
        { 'I2A2', 111, 114 },
        { 'I2A2', 114, 117 },
        { 'I2A2', 117, 120 },
        { 'I2A2', 120, 123 },
        { 'I2A2', 123, 126 },
        { 'I2A3', 126, 129 },
        { 'I2A14', 129, 132 },
        { 'I2A2', 132, 135 },
        { 'I2A2', 135, 138 },
        { 'I2A14', 138, 141 },
        { 'I2A3', 141, 144 },
        { 'I2A10', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A42', 3, 6 },
        { 'I2A17', 6, 9 },
        { 'I2A43', 9, 12 },
        { 'I2A44', 12, 15 },
        { 'I2A45', 15, 18 },
        { 'I2A17', 18, 21 },
        { 'I2A46', 21, 24 },
        { 'I2A23', 24, 27 },
        { 'I2A23', 27, 30 },
        { 'I2A23', 30, 33 },
        { 'I2A23', 33, 36 },
        { 'I2A25', 36, 39 },
        { 'I2A25', 39, 42 },
        { 'I2A47', 42, 45 },
        { 'I2A23', 45, 48 },
        { 'I2A25', 48, 51 },
        { 'I2A48', 51, 54 },
        { 'I2A10', 54, 57 },
        { 'I2A45', 57, 60 },
        { 'I2A49', 60, 63 },
        { 'I2A10', 63, 66 },
        { 'I2A43', 66, 69 },
        { 'I2A50', 69, 72 },
        { 'I2A51', 72, 75 },
        { 'I2A10', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A10', 96, 99 },
        { 'I2A16', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A17', 105, 108 },
        { 'I2A10', 108, 111 },
        { 'I2A20', 111, 114 },
        { 'I2A3', 114, 117 },
        { 'I2A3', 117, 120 },
        { 'I2A3', 120, 123 },
        { 'I2A3', 123, 126 },
        { 'I2A3', 126, 129 },
        { 'I2A3', 129, 132 },
        { 'I2A3', 132, 135 },
        { 'I2A3', 135, 138 },
        { 'I2A3', 138, 141 },
        { 'I2A3', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A52', 0, 3 },
        { 'I2A53', 3, 6 },
        { 'I2A23', 6, 9 },
        { 'I2A54', 9, 12 },
        { 'I2A55', 12, 15 },
        { 'I2A56', 15, 18 },
        { 'I2A17', 18, 21 },
        { 'I2A57', 21, 24 },
        { 'I2A58', 24, 27 },
        { 'I2A58', 27, 30 },
        { 'I2A59', 30, 33 },
        { 'I2A25', 33, 36 },
        { 'I2A25', 36, 39 },
        { 'I2A25', 39, 42 },
        { 'I2A25', 42, 45 },
        { 'I2A25', 45, 48 },
        { 'I2A17', 48, 51 },
        { 'I2A60', 51, 54 },
        { 'I2A43', 54, 57 },
        { 'I2A56', 57, 60 },
        { 'I2A61', 60, 63 },
        { 'I2A62', 63, 66 },
        { 'I2A43', 66, 69 },
        { 'I2A50', 69, 72 },
        { 'I2A63', 72, 75 },
        { 'I2A64', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A65', 96, 99 },
        { 'I2A66', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A17', 105, 108 },
        { 'I2A52', 108, 111 },
        { 'I2A67', 111, 114 },
        { 'I2A18', 114, 117 },
        { 'I2A68', 117, 120 },
        { 'I2A69', 120, 123 },
        { 'I2A70', 123, 126 },
        { 'I2A3', 126, 129 },
        { 'I2A3', 129, 132 },
        { 'I2A3', 132, 135 },
        { 'I2A70', 135, 138 },
        { 'I2A71', 138, 141 },
        { 'I2A10', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A18', 0, 3 },
        { 'I2A28', 3, 6 },
        { 'I2A23', 6, 9 },
        { 'I2A23', 9, 12 },
        { 'I2A23', 12, 15 },
        { 'I2A23', 15, 18 },
        { 'I2A25', 18, 21 },
        { 'I2A25', 21, 24 },
        { 'I2A25', 24, 27 },
        { 'I2A17', 27, 30 },
        { 'I2A26', 30, 33 },
        { 'I2A25', 33, 36 },
        { 'I2A25', 36, 39 },
        { 'I2A18', 39, 42 },
        { 'I2A27', 42, 45 },
        { 'I2A25', 45, 48 },
        { 'I2A25', 48, 51 },
        { 'I2A25', 51, 54 },
        { 'I2A25', 54, 57 },
        { 'I2A25', 57, 60 },
        { 'I2A25', 60, 63 },
        { 'I2A25', 63, 66 },
        { 'I2A25', 66, 69 },
        { 'I2A26', 69, 72 },
        { 'I2A17', 72, 75 },
        { 'I2A17', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A18', 96, 99 },
        { 'I2A38', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A17', 105, 108 },
        { 'I2A18', 108, 111 },
        { 'I2A18', 111, 114 },
        { 'I2A18', 114, 117 },
        { 'I2A18', 117, 120 },
        { 'I2A18', 120, 123 },
        { 'I2A18', 123, 126 },
        { 'I2A10', 126, 129 },
        { 'I2A10', 129, 132 },
        { 'I2A10', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A17', 0, 3 },
        { 'I2A26', 3, 6 },
        { 'I2A25', 6, 9 },
        { 'I2A25', 9, 12 },
        { 'I2A25', 12, 15 },
        { 'I2A25', 15, 18 },
        { 'I2A25', 18, 21 },
        { 'I2A25', 21, 24 },
        { 'I2A25', 24, 27 },
        { 'I2A25', 27, 30 },
        { 'I2A25', 30, 33 },
        { 'I2A25', 33, 36 },
        { 'I2A25', 36, 39 },
        { 'I2A25', 39, 42 },
        { 'I2A25', 42, 45 },
        { 'I2A25', 45, 48 },
        { 'I2A25', 48, 51 },
        { 'I2A25', 51, 54 },
        { 'I2A25', 54, 57 },
        { 'I2A25', 57, 60 },
        { 'I2A25', 60, 63 },
        { 'I2A25', 63, 66 },
        { 'I2A25', 66, 69 },
        { 'I2A25', 69, 72 },
        { 'I2A26', 72, 75 },
        { 'I2A17', 75, 78 },
        { 'I2A18', 78, 81 },
        { 'I2A38', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A38', 90, 93 },
        { 'I2A18', 93, 96 },
        { 'I2A17', 96, 99 },
        { 'I2A17', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A17', 105, 108 },
        { 'I2A18', 108, 111 },
        { 'I2A18', 111, 114 },
        { 'I2A18', 114, 117 },
        { 'I2A18', 117, 120 },
        { 'I2A38', 120, 123 },
        { 'I2A17', 123, 126 },
        { 'I2A18', 126, 129 },
        { 'I2A72', 129, 132 },
        { 'I2A10', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A73', 9, 12 },
        { 'I2A74', 12, 15 },
        { 'I2A75', 15, 18 },
        { 'I2A45', 18, 21 },
        { 'I2A45', 21, 24 },
        { 'I2A45', 24, 27 },
        { 'I2A76', 27, 30 },
        { 'I2A77', 30, 33 },
        { 'I2A78', 33, 36 },
        { 'I2A78', 36, 39 },
        { 'I2A76', 39, 42 },
        { 'I2A79', 42, 45 },
        { 'I2A45', 45, 48 },
        { 'I2A45', 48, 51 },
        { 'I2A45', 51, 54 },
        { 'I2A45', 54, 57 },
        { 'I2A80', 57, 60 },
        { 'I2A81', 60, 63 },
        { 'I2A82', 63, 66 },
        { 'I2A82', 66, 69 },
        { 'I2A83', 69, 72 },
        { 'I2A84', 72, 75 },
        { 'I2A85', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A17', 96, 99 },
        { 'I2A86', 99, 102 },
        { 'I2A87', 102, 105 },
        { 'I2A17', 105, 108 },
        { 'I2A17', 108, 111 },
        { 'I2A86', 111, 114 },
        { 'I2A87', 114, 117 },
        { 'I2A17', 117, 120 },
        { 'I2A17', 120, 123 },
        { 'I2A17', 123, 126 },
        { 'I2A17', 126, 129 },
        { 'I2A88', 129, 132 },
        { 'I2A85', 132, 135 },
        { 'I2A10', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A10', 12, 15 },
        { 'I2A10', 15, 18 },
        { 'I2A25', 18, 21 },
        { 'I2A89', 21, 24 },
        { 'I2A45', 24, 27 },
        { 'I2A45', 27, 30 },
        { 'I2A45', 30, 33 },
        { 'I2A45', 33, 36 },
        { 'I2A45', 36, 39 },
        { 'I2A56', 39, 42 },
        { 'I2A56', 42, 45 },
        { 'I2A56', 45, 48 },
        { 'I2A56', 48, 51 },
        { 'I2A56', 51, 54 },
        { 'I2A56', 54, 57 },
        { 'I2A45', 57, 60 },
        { 'I2A45', 60, 63 },
        { 'I2A45', 63, 66 },
        { 'I2A18', 66, 69 },
        { 'I2A38', 69, 72 },
        { 'I2A17', 72, 75 },
        { 'I2A17', 75, 78 },
        { 'I2A17', 78, 81 },
        { 'I2A17', 81, 84 },
        { 'I2A17', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A17', 96, 99 },
        { 'I2A29', 99, 102 },
        { 'I2A10', 102, 105 },
        { 'I2A17', 105, 108 },
        { 'I2A18', 108, 111 },
        { 'I2A38', 111, 114 },
        { 'I2A17', 114, 117 },
        { 'I2A17', 117, 120 },
        { 'I2A38', 120, 123 },
        { 'I2A18', 123, 126 },
        { 'I2A18', 126, 129 },
        { 'I2A38', 129, 132 },
        { 'I2A17', 132, 135 },
        { 'I2A10', 135, 138 },
        { 'I2A10', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A90', 12, 15 },
        { 'I2A91', 15, 18 },
        { 'I2A92', 18, 21 },
        { 'I2A26', 21, 24 },
        { 'I2A93', 24, 27 },
        { 'I2A94', 27, 30 },
        { 'I2A95', 30, 33 },
        { 'I2A96', 33, 36 },
        { 'I2A97', 36, 39 },
        { 'I2A97', 39, 42 },
        { 'I2A97', 42, 45 },
        { 'I2A97', 45, 48 },
        { 'I2A97', 48, 51 },
        { 'I2A98', 51, 54 },
        { 'I2A96', 54, 57 },
        { 'I2A17', 57, 60 },
        { 'I2A99', 60, 63 },
        { 'I2A100', 63, 66 },
        { 'I2A100', 66, 69 },
        { 'I2A38', 69, 72 },
        { 'I2A38', 72, 75 },
        { 'I2A100', 75, 78 },
        { 'I2A101', 78, 81 },
        { 'I2A102', 81, 84 },
        { 'I2A23', 84, 87 },
        { 'I2A103', 87, 90 },
        { 'I2A104', 90, 93 },
        { 'I2A100', 93, 96 },
        { 'I2A100', 96, 99 },
        { 'I2A99', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A105', 105, 108 },
        { 'I2A106', 108, 111 },
        { 'I2A107', 111, 114 },
        { 'I2A17', 114, 117 },
        { 'I2A18', 117, 120 },
        { 'I2A18', 120, 123 },
        { 'I2A18', 123, 126 },
        { 'I2A106', 126, 129 },
        { 'I2A107', 129, 132 },
        { 'I2A17', 132, 135 },
        { 'I2A17', 135, 138 },
        { 'I2A108', 138, 141 },
        { 'I2A105', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A0', 9, 12 },
        { 'I2A16', 12, 15 },
        { 'I2A17', 15, 18 },
        { 'I2A25', 18, 21 },
        { 'I2A25', 21, 24 },
        { 'I2A25', 24, 27 },
        { 'I2A25', 27, 30 },
        { 'I2A27', 30, 33 },
        { 'I2A18', 33, 36 },
        { 'I2A18', 36, 39 },
        { 'I2A18', 39, 42 },
        { 'I2A18', 42, 45 },
        { 'I2A18', 45, 48 },
        { 'I2A18', 48, 51 },
        { 'I2A18', 51, 54 },
        { 'I2A18', 54, 57 },
        { 'I2A18', 57, 60 },
        { 'I2A38', 60, 63 },
        { 'I2A17', 63, 66 },
        { 'I2A17', 66, 69 },
        { 'I2A17', 69, 72 },
        { 'I2A38', 72, 75 },
        { 'I2A18', 75, 78 },
        { 'I2A23', 78, 81 },
        { 'I2A23', 81, 84 },
        { 'I2A23', 84, 87 },
        { 'I2A23', 87, 90 },
        { 'I2A28', 90, 93 },
        { 'I2A18', 93, 96 },
        { 'I2A18', 96, 99 },
        { 'I2A38', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A10', 105, 108 },
        { 'I2A17', 108, 111 },
        { 'I2A17', 111, 114 },
        { 'I2A17', 114, 117 },
        { 'I2A17', 117, 120 },
        { 'I2A17', 120, 123 },
        { 'I2A17', 123, 126 },
        { 'I2A17', 126, 129 },
        { 'I2A17', 129, 132 },
        { 'I2A17', 132, 135 },
        { 'I2A17', 135, 138 },
        { 'I2A29', 138, 141 },
        { 'I2A10', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A109', 9, 12 },
        { 'I2A110', 12, 15 },
        { 'I2A18', 15, 18 },
        { 'I2A111', 18, 21 },
        { 'I2A112', 21, 24 },
        { 'I2A25', 24, 27 },
        { 'I2A113', 27, 30 },
        { 'I2A114', 30, 33 },
        { 'I2A17', 33, 36 },
        { 'I2A18', 36, 39 },
        { 'I2A115', 39, 42 },
        { 'I2A115', 42, 45 },
        { 'I2A115', 45, 48 },
        { 'I2A17', 48, 51 },
        { 'I2A17', 51, 54 },
        { 'I2A17', 54, 57 },
        { 'I2A17', 57, 60 },
        { 'I2A17', 60, 63 },
        { 'I2A17', 63, 66 },
        { 'I2A17', 66, 69 },
        { 'I2A17', 69, 72 },
        { 'I2A38', 72, 75 },
        { 'I2A18', 75, 78 },
        { 'I2A116', 78, 81 },
        { 'I2A117', 81, 84 },
        { 'I2A23', 84, 87 },
        { 'I2A23', 87, 90 },
        { 'I2A23', 90, 93 },
        { 'I2A23', 93, 96 },
        { 'I2A17', 96, 99 },
        { 'I2A17', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A10', 105, 108 },
        { 'I2A115', 108, 111 },
        { 'I2A118', 111, 114 },
        { 'I2A17', 114, 117 },
        { 'I2A17', 117, 120 },
        { 'I2A17', 120, 123 },
        { 'I2A17', 123, 126 },
        { 'I2A17', 126, 129 },
        { 'I2A17', 129, 132 },
        { 'I2A17', 132, 135 },
        { 'I2A115', 135, 138 },
        { 'I2A119', 138, 141 },
        { 'I2A10', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A17', 9, 12 },
        { 'I2A26', 12, 15 },
        { 'I2A25', 15, 18 },
        { 'I2A25', 18, 21 },
        { 'I2A25', 21, 24 },
        { 'I2A25', 24, 27 },
        { 'I2A17', 27, 30 },
        { 'I2A17', 30, 33 },
        { 'I2A17', 33, 36 },
        { 'I2A10', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A18', 48, 51 },
        { 'I2A18', 51, 54 },
        { 'I2A18', 54, 57 },
        { 'I2A10', 57, 60 },
        { 'I2A10', 60, 63 },
        { 'I2A10', 63, 66 },
        { 'I2A10', 66, 69 },
        { 'I2A10', 69, 72 },
        { 'I2A10', 72, 75 },
        { 'I2A10', 75, 78 },
        { 'I2A18', 78, 81 },
        { 'I2A28', 81, 84 },
        { 'I2A23', 84, 87 },
        { 'I2A23', 87, 90 },
        { 'I2A22', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A17', 96, 99 },
        { 'I2A17', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A10', 105, 108 },
        { 'I2A18', 108, 111 },
        { 'I2A18', 111, 114 },
        { 'I2A18', 114, 117 },
        { 'I2A17', 117, 120 },
        { 'I2A17', 120, 123 },
        { 'I2A17', 123, 126 },
        { 'I2A17', 126, 129 },
        { 'I2A38', 129, 132 },
        { 'I2A18', 132, 135 },
        { 'I2A10', 135, 138 },
        { 'I2A10', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A0', 3, 6 },
        { 'I2A0', 6, 9 },
        { 'I2A17', 9, 12 },
        { 'I2A26', 12, 15 },
        { 'I2A25', 15, 18 },
        { 'I2A17', 18, 21 },
        { 'I2A17', 21, 24 },
        { 'I2A17', 24, 27 },
        { 'I2A17', 27, 30 },
        { 'I2A29', 30, 33 },
        { 'I2A10', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A0', 51, 54 },
        { 'I2A0', 54, 57 },
        { 'I2A10', 57, 60 },
        { 'I2A72', 60, 63 },
        { 'I2A18', 63, 66 },
        { 'I2A18', 66, 69 },
        { 'I2A18', 69, 72 },
        { 'I2A18', 72, 75 },
        { 'I2A18', 75, 78 },
        { 'I2A10', 78, 81 },
        { 'I2A72', 81, 84 },
        { 'I2A18', 84, 87 },
        { 'I2A17', 87, 90 },
        { 'I2A17', 90, 93 },
        { 'I2A17', 93, 96 },
        { 'I2A17', 96, 99 },
        { 'I2A17', 99, 102 },
        { 'I2A17', 102, 105 },
        { 'I2A18', 105, 108 },
        { 'I2A10', 108, 111 },
        { 'I2A120', 111, 114 },
        { 'I2A23', 114, 117 },
        { 'I2A18', 117, 120 },
        { 'I2A28', 120, 123 },
        { 'I2A23', 123, 126 },
        { 'I2A18', 126, 129 },
        { 'I2A28', 129, 132 },
        { 'I2A23', 132, 135 },
        { 'I2A10', 135, 138 },
        { 'I2A10', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
      {
        { 'I2A0', 0, 3 },
        { 'I2A121', 3, 6 },
        { 'I2A122', 6, 9 },
        { 'I2A123', 9, 12 },
        { 'I2A124', 12, 15 },
        { 'I2A125', 15, 18 },
        { 'I2A123', 18, 21 },
        { 'I2A126', 21, 24 },
        { 'I2A10', 24, 27 },
        { 'I2A10', 27, 30 },
        { 'I2A0', 30, 33 },
        { 'I2A0', 33, 36 },
        { 'I2A0', 36, 39 },
        { 'I2A0', 39, 42 },
        { 'I2A0', 42, 45 },
        { 'I2A0', 45, 48 },
        { 'I2A0', 48, 51 },
        { 'I2A0', 51, 54 },
        { 'I2A0', 54, 57 },
        { 'I2A0', 57, 60 },
        { 'I2A0', 60, 63 },
        { 'I2A10', 63, 66 },
        { 'I2A10', 66, 69 },
        { 'I2A10', 69, 72 },
        { 'I2A10', 72, 75 },
        { 'I2A10', 75, 78 },
        { 'I2A0', 78, 81 },
        { 'I2A0', 81, 84 },
        { 'I2A10', 84, 87 },
        { 'I2A127', 87, 90 },
        { 'I2A19', 90, 93 },
        { 'I2A125', 93, 96 },
        { 'I2A127', 96, 99 },
        { 'I2A19', 99, 102 },
        { 'I2A125', 102, 105 },
        { 'I2A127', 105, 108 },
        { 'I2A0', 108, 111 },
        { 'I2A128', 111, 114 },
        { 'I2A125', 114, 117 },
        { 'I2A125', 117, 120 },
        { 'I2A129', 120, 123 },
        { 'I2A10', 123, 126 },
        { 'I2A10', 126, 129 },
        { 'I2A10', 129, 132 },
        { 'I2A10', 132, 135 },
        { 'I2A0', 135, 138 },
        { 'I2A0', 138, 141 },
        { 'I2A0', 141, 144 },
        { 'I2A0', 144, 147 },
      },
    }
    local bulbasaur = {
      [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣸⣿⣀⣿⣿⣿⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⠀⠀⠀⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⢰⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣤⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⡄⠀⠀ ]],
      [[ ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ]],
      [[ ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿ ]],
      [[ ⠀⢠⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀ ]],
      [[ ⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠈⠉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀ ]],
      [[ ⠀⢸⣿⣿⣇⣀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣀⡸⠿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣀⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀ ]],
      [[ ⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣿⡇⠀⣿⣿⣷⣶⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡏⠉⠀ ]],
      [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣀⠿⠿⠿⠀⠀⠀⠀ ]],
      [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⡄⠀⠀⠀⠀⠀ ]],
      [[ ⠉⠉⠉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⠸⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀ ]],
      [[ ⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣤⣤⠀ ]],
      [[ ⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ]],
      [[ ⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ]],
      [[ ⠀⠀⠀⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀ ]],
      [[ ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡿⠿⠀⠀⠀⠀⠿⠿⠿⠀⢀⣀⣀⣀⣀⣀⠿⢿⣿⣿⣿⣿⣿⣿⣿⣀⠿⢿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀ ]],
      [[ ⠀⢠⣤⠛⢻⣿⠛⠛⠛⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠛⠛⠛⠀⠘⠛⠛⢻⣿⠛⢻⣿⠛⠀⢸⣿⣿⡟⠛⠛⠛⠛⠀⠀⠀⠀ ]],
    }

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
      val = bulbasaur,
      opts = { hl = bulbasaur_hl, position = 'center' },
    }

    local git_section = {
      type = 'text',
      val = get_git_repo() .. '  ' .. get_git_branch(),
      opts = { position = 'center', hl = colors.purple },
    }

    local cwd_section = {
      type = 'text',
      val = icons.ui.open_folder .. '  ' .. shorten_home(base_directory),
      opts = { position = 'center', hl = colors.blue },
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
        -- dashboard.button('f', icons.ui.tree .. '  File Tree', '<cmd>NvimTreeToggle<CR>'),
        dashboard.button('f', icons.ui.tree .. '  File Tree', '<cmd>Neotree position=right<cr>'),
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
