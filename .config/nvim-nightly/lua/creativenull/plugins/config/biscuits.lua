if package.loaded['nvim-treesitter'] then
  require 'nvim-biscuits'.setup {
    default_config = {
      max_length = 32,
      min_distance = 5,
      prefix_string = '>> '
    }
  }
end
