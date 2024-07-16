-- Really cool setup with git commit history grid
-- https://github.com/GustafB/dotfiles/blob/master/config/nvim/lua/cafebabe/lazy/dashboard.lua

-- Interesting example of a bulbasaur ascii art, but it's a picture
-- https://imgur.com/gallery/ascii-pokedex-generation-1-1-3-version-2-67uYiaQ

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
    -- 'PreProc', -- pink
    'Special', -- pink
    'Statement', -- purple
    -- 'Type', -- yellow
    -- 'Underlined', -- literally underlined
  }
  return colors[math.random(#colors)]
end
--
-- return {
--   'goolord/alpha-nvim',
--   dependencies = {
--     'nvim-tree/nvim-web-devicons',
--     'nvim-tree/nvim-tree.lua', -- NOTE: see note below
--   },
--
--   config = function()
--     local alpha = require 'alpha'
--     local dashboard = require 'alpha.themes.startify'
--
--     local battle = {
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⣄⡀⠀⠀⠀⠀⠀⠀⣀⠀⠀⡇⢹⣦⡀⠀⢰⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢠⣀⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣆⡉⠙⠲⠤⢤⣀⡀⡏⣷⣄⣇⠀⢻⣿⣦⢸⠈⣷⣄⠀⠀⠀⢠⣠⡤⠼⠒⠋⢉⣬⣿⣿⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡿⣷⣤⣄⣀⣿⣿⣁⣾⡿⣿⣦⣄⣾⠽⡿⣧⠾⡭⢷⡚⠉⠉⠁⢀⣀⣤⣾⣿⣿⡿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣟⣻⣭⣉⡉⠉⠛⣿⣣⢝⣧⣄⠉⠙⢻⡷⣡⠟⣜⡯⢷⣒⣒⣲⡿⣞⢯⣹⣾⡟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣿⣵⣿⣿⣷⣤⣲⠿⣜⣺⣼⣿⣧⣒⣶⠿⣥⢻⡬⢷⣫⡝⣭⡳⣹⡜⣮⡷⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⣤⣀⠈⢙⣯⢳⡹⣿⡉⠉⠙⢩⢿⢮⡝⣲⢣⣏⠷⡷⡟⢷⡳⢥⢿⢻⠤⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⣼⢿⡇⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⢾⣿⣿⣤⡞⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣷⣬⣿⢏⢧⡳⣭⣿⣧⣒⣲⡿⢳⡜⣣⠗⣎⡏⢷⣩⢧⣝⣮⣛⣶⡟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⢀⣿⣌⢿⢿⡇⠀⠀⠀⠀⠀⢀⣴⣴⠛⣱⣾⣿⣿⣿⣿⡏⢀⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣼⣏⡉⡉⠙⡿⣎⣿⣻⠉⠁⠀⢿⡧⣝⢳⣚⣥⠻⣜⡼⢣⢷⠟⡛⢛⡻⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⢠⡞⠋⠁⠀⣺⣿⡀⠀⠀⠀⢰⣟⣿⠿⢋⣃⣿⣿⡟⠀⣯⡵⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⠉⣬⣿⣿⣷⣶⡷⣻⠜⡽⣻⣷⣷⣾⡽⡳⢎⡳⣜⡲⣛⡴⡹⢏⣿⢦⡑⣂⣯⠷⣘⠿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⣿⡁⠀⠀⣸⠀⣿⣤⠀⠀⣠⣿⡿⠁⡴⠿⢹⣿⣿⢁⣀⣀⣀⣿⣹⣧⢀⣰⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣧⣴⣶⣿⣭⡀⠌⣹⣗⣣⡿⠗⠛⠉⢸⡷⣍⡗⣫⠵⣎⡵⢣⡳⡝⢯⡜⣏⠿⣙⣮⡹⣍⡞⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠘⣷⣦⠤⠋⣶⣿⡧⠴⠾⣿⣿⠀⠒⠀⠀⣾⣻⣷⠿⣿⣿⣿⣶⣿⣿⣼⡿⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⣟⣲⣧⣿⣿⣿⣿⣿⣟⡬⢳⠿⣿⢿⣶⣿⣛⡴⢫⣕⡫⡖⣭⠳⣕⣫⣗⣾⣬⣷⣩⠖⣵⢺⣜⣿⣿⢿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⢀⣶⣮⣿⣼⣶⡛⠀⠀⠀⠘⣻⣿⣾⡄⢀⣴⣛⣾⡷⠀⠀⠹⣿⣿⣿⣿⣹⣯⣴⣿⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢻⣿⣿⣿⣿⠛⢉⣹⣧⣏⣷⣹⡾⠋⢁⣹⣶⣩⠗⣮⡱⣝⣲⣻⣼⣿⣿⢯⡿⣽⢿⡿⣿⣿⣾⢿⡽⣯⢿⣷⡂⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠙⠻⣶⣦⣀⣩⡁⠀⣤⣼⡟⠉⠈⣻⣿⣾⠿⠿⠁⣶⣶⡌⢻⣿⣌⣻⣿⣼⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⣿⣿⣿⣿⢾⣿⣾⣿⣷⣾⣿⣿⣻⢿⡿⣷⢿⡿⣾⣻⣟⣾⣻⡿⣿⣯⣿⣽⣳⣟⣯⣿⣽⣻⣿⣿⣷⠂⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⣾⠹⠟⢣⣭⣶⣿⠒⡇⠀⣀⣟⣁⣀⣶⠤⠤⢤⣿⣡⣸⣿⡿⣿⡮⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⣿⣟⡿⣽⣻⣾⣷⣯⢿⣽⣻⢾⡽⣯⣟⣯⢿⣽⣳⣟⣾⣳⢯⡿⣽⣻⣟⡿⣿⡏⠛⠛⠻⡿⢹⣟⠿⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠘⣻⠀⠈⠛⠛⠹⠈⢀⣠⣶⣾⢷⡾⠁⠰⢿⣶⠀⣿⣿⡘⣷⣹⣿⣾⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠟⠻⢟⡴⢣⠿⣿⡾⣽⢯⣟⣷⣻⣞⡿⣞⣷⣻⢾⡽⣯⣟⡷⣯⣿⣿⣿⡉⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠘⡏⠀⡀⠀⣀⣠⣾⣿⣽⣿⣷⣾⡇⢠⣴⣾⣿⢾⣿⣿⢳⣿⣿⡉⢿⣿⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣴⣞⣍⣦⣬⣷⣞⡭⣷⣿⣿⢿⣽⣻⣞⣷⣻⢾⣿⡽⣾⡽⣯⣟⡷⣯⣟⣷⣻⣿⣟⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⢿⣦⣽⣾⣿⠿⠾⣿⣿⣿⣿⡾⣧⡬⠁⠸⣿⠇⣿⣿⣿⣿⢋⣿⠈⢩⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⢿⣻⣽⣻⢿⣾⢿⣽⣻⣞⣷⣻⢾⣽⣻⣯⣟⣷⣻⢷⣯⣟⣷⣻⣞⡷⣯⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⠀⠈⣹⠟⢹⡎⡱⣮⡿⠁⢉⣹⣿⣿⡂⠋⠀⠀⣻⡛⠋⢙⣿⡤⠽⣸⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣿⣿⣿⣾⣽⣻⣾⢯⣷⣻⢾⡷⣯⢿⡾⣽⣿⣟⡾⣽⣻⢾⡽⣞⣷⢯⣟⣷⣻⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--       [[⠀⠀⠀⠀⠀⠀⠀⢀⡴⢯⣠⢿⣐⡷⠟⠁⠀⠘⠻⠟⠻⢦⡀⢀⣠⣿⠇⠀⠀⢸⡹⠿⢏⡍⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠿⢿⠛⠛⠛⠻⢿⣽⣯⣿⣽⣾⣻⣽⣾⣽⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
--     }
--     local bulbasaur = {
--       [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠏⣉⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
--       [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⢅⣿⢄⣤⠛⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿]],
--       [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⠉⢔⣾⢕⣿⢕⣶⠉⠉⠿⢷⣶⣉⣉⣿⣿⣿⣿⣿]],
--       [[⣿⣿⣿⣿⣿⣿⣿⣿⣇⣸⣿⣿⣿⢕⣿⢕⣿⢕⣿⣿⣿⣧⣤⠛⣿⣿⡸⢿⣿⣿]],
--       [[⣿⣿⣿⡟⠛⠛⣿⡇⢸⡟⠛⠛⢪⣿⠓⠛⣤⣤⡜⢻⣿⣿⣿⣿⣀⢿⣧⡜⢻⣿]],
--       [[⣿⣿⡇⢸⣿⠉⢰⣶⣶⡎⠉⣿⣷⣶⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⢕⢸⢕⡇⢸⣿]],
--       [[⣿⡇⢸⣿⣿⣿⣿⣿⣧⣤⣿⠛⣿⣿⠿⢿⣿⣿⣿⡇⢸⣿⣿⣿⠿⣸⡟⢣⣼⣿]],
--       [[⣿⡏⢱⣆⠸⣿⣀⣸⣿⣿⣀⠿⠉⡀⢿⣷⡎⢹⣿⣷⡎⢉⣹⠉⠶⢏⣱⣾⣿⣿]],
--       [[⡇⢸⡟⠓⢡⣿⣿⣿⣿⣿⣿⡀⠛⠊⢸⣿⣧⣼⣿⣿⡇⢸⣿⣶⣶⣧⡜⢻⣿⣿]],
--       [[⣷⡎⠉⠹⢷⡾⠿⠷⠾⠿⢏⣉⣉⡹⢏⣱⡆⣀⣿⡏⢹⣿⡿⢿⣿⡿⢷⡎⢹⣿]],
--       [[⣿⣿⡇⢠⡜⢣⣤⡀⢀⢔⢕⢕⢕⠕⠛⢣⣼⡟⠃⣤⣀⠘⢻⡇⢸⠃⣼⣧⡜⢻]],
--       [[⣿⡇⢸⣿⣿⣶⣶⣉⡁⠰⠶⠶⠶⠶⣉⡉⢱⡆⣿⣿⣿⣶⣾⡇⠰⣿⡏⢹⡇⢸]],
--       [[⣿⢸⡟⢻⣿⣿⠿⣀⣸⣿⣿⣿⣿⣿⣿⣿⡇⢸⡟⢻⣿⡟⢣⣼⣿⣿⣿⣿⣿⣿]],
--       [[⣿⣷⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿]],
--     }
--     local c = pick_color()
--     dashboard.section.header.opts.hl = c
--     local neovim = {
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                     ]],
--       [[       ████ ██████           █████      ██                     ]],
--       [[      ███████████             █████                             ]],
--       [[      █████████ ███████████████████ ███   ███████████   ]],
--       [[     █████████  ███    █████████████ █████ ██████████████   ]],
--       [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
--       [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
--       [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       -- c,
--     }
--     dashboard.section.header.val = neovim
--
--     alpha.setup(dashboard.opts)
--
--     -- TODO: havent figured out how to disable lualine on the alpha dashboard yet
--     vim.api.nvim_create_autocmd('User', {
--       pattern = 'AlphaReady',
--       desc = 'Disable status and tabline for alpha',
--       callback = function()
--         -- vim.go.laststatus = 0
--         vim.opt.showtabline = 0
--       end,
--     })
--     vim.api.nvim_create_autocmd('BufUnload', {
--       buffer = 0,
--       desc = 'Enable status and tabline after alpha',
--       callback = function()
--         -- vim.go.laststatus = 3
--         vim.opt.showtabline = 2
--       end,
--     })
--
--     -- NOTE: This gets nvim-tree to open on startup, and thus is an implicit dependency
--     vim.api.nvim_create_autocmd('User', {
--       once = true,
--       pattern = 'LazyVimStarted',
--       desc = 'Open NvimTree after startup',
--       callback = function()
--         -- local stats = require('lazy').stats()
--         -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
--         -- dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
--         -- pcall(vim.cmd.AlphaRedraw)
--
--         vim.cmd 'NvimTreeToggle'
--       end,
--     })
--   end,
-- }

return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  config = function()
    -- Import alpha and dashboard
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Define custom icons
    local icons = {
      ui = {
        file = '',
        files = '',
        open_folder = '',
        config = '',
        close = '󰈆',
        git = '',
      },
    }

    local function whitespace_only(str)
      return str:match '^%s*$' ~= nil
    end

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

    local function format_git_header()
      local git_dashboard_raw = require('git-dashboard-nvim').setup {
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        -- how_contributions_count = false,
        -- empty_square = ' ',
        -- filled_squares = { '', '', '', '', '', '' },
        -- show_only_weeks_with_commits = true,
      }
      local git_dashboard = {}
      for _, line in ipairs(git_dashboard_raw) do
        if not whitespace_only(line) then
          table.insert(git_dashboard, line)
        end
      end

      local git_repo = git_dashboard[1]
      local git_branch = git_dashboard[#git_dashboard]

      if git_repo == nil and git_branch == nil then
        return {
          type = 'text',
          val = '',
          opts = { position = 'center' },
        }, {}
      end

      local git_branch_section = {
        type = 'text',
        val = ' ' .. git_repo .. ':' .. string.sub(git_branch, 5, #git_branch),
        opts = { position = 'center', hl = pick_color() },
      }

      return git_branch_section, { unpack(git_dashboard, 2, #git_dashboard - 1) }
    end

    -- Define custom header with ASCII art or any custom message

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
    local git_branch_section, commit_history = format_git_header()

    for _, line in ipairs(commit_history) do
      ascii_header = ascii_header .. '\n' .. string.rep(' ', 3) .. line
    end

    local custom_header = center_header(ascii_header)
    local c = pick_color()
    local header = { type = 'text', val = custom_header, opts = { hl = c } }

    local buttons = {
      type = 'group',
      val = {
        dashboard.button('e', icons.ui.file .. '  New file', '<cmd>new<CR>'),
        dashboard.button('o', icons.ui.files .. '  Recent Files', '<cmd>Telescope oldfiles<cr>'),
        -- dashboard.button('f', icons.ui.open_folder .. '  Explorer', '<cmd>Oil<cr>'),
        -- dashboard.button('c', icons.ui.config .. '  Neovim config', '<cmd>Oil /home/cafebabe/install/dotfiles/config/nvim<cr>'),
        -- dashboard.button('g', icons.ui.git .. '  Open Git', '<cmd>Neogit<CR>'),
        dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<cr>'),
        dashboard.button('q', icons.ui.close .. '  Quit NVIM', ':qa<CR>'),
      },
      opts = {},
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
        pad(4),
        header,
        pad(1),
        git_branch_section,
        pad(1),
        buttons,
        -- pad(1),
        -- bottom_section,
        -- pad(1),
        -- footer,
      },
    }

    -- NOTE: This gets nvim-tree to open on startup, and thus is an implicit dependency
    vim.api.nvim_create_autocmd('User', {
      once = true,
      pattern = 'LazyVimStarted',
      desc = 'Open NvimTree after startup',
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
