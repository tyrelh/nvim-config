-- https://github.com/RRethy/vim-illuminate
return {
  'RRethy/vim-illuminate',
  config = function()
    require('illuminate').configure {
      -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
      filetypes_denylist = {
        'dirvish',
        'fugitive',
        'alpha',
        'neotree',
      },
    }
  end,
}
