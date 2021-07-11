local lsp_executable = 'vls'
if vim.fn.executable(lsp_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', lsp_executable))
  return
end

local root_pattern = require 'lspconfig'.util.root_pattern

require 'cnull.core.lsp'.setup('vuels', {
  root_dir = root_pattern('package.json', 'vue.config.js'),
  init_options = {
    config = {
      css = {},
      emmet = {},
      html = {
        suggest = {},
      },
      javascript = {
        format = {},
      },
      stylusSupremacy = {},
      typescript = {
        format = {},
      },
      vetur = {
        completion = {
          autoImport = false,
          tagCasing = 'kebab',
          useScaffoldSnippets = false,
        },
        format = {
          defaultFormatter = {
            js = 'none',
            ts = 'none',
          },
          defaultFormatterOptions = {},
          scriptInitialIndent = false,
          styleInitialIndent = false,
        },
        useWorkspaceDependencies = false,
        validation = {
          script = true,
          style = true,
          template = true,
        },
      },
    },
  },
})
