local M = {}

-- Accept completion from ddc.vim or from vsnip
local function confirm_completion(default)
  if vim.call('ddc#map#pum_visible') == 1 then
    if vim.call('vsnip#expandable') == 1 then
      return "<Plug>(vsnip-expand)"
    elseif vim.call('ddc#map#can_complete') == 1 then
      return vim.call('ddc#map#extend')
    end
  end

  return default
end

local function enable()
  vim.call('ddc#enable')
  vim.call('signature_help#enable')
end

function M.Setup()
  local sources = { 'nvim-lsp', 'vsnip', 'around', 'buffer' }

  local sourceOptions = {
    ['_'] = {
      matchers = { 'matcher_fuzzy' },
      sorters = { 'sorter_fuzzy' },
      converters = { 'converter_fuzzy' },
    },
    ['nvim-lsp'] = {
      mark = 'Language',
      forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
      maxCandidates = 10,
    },
    vsnip = {
      mark = 'Snippet',
      maxCandidates = 5,
    },
    around = {
      mark = 'Local',
      maxCandidates = 3,
    },
    buffer = {
      mark = 'Buffer',
      maxCandidates = 3,
    },
  }

  local sourceParams = {
    ['nvim-lsp'] = {
      kindLabels = {
        Class = 'ﴯ Class',
        Color = ' Color',
        Constant = ' Constant',
        Constructor = ' New',
        Enum = ' Enum',
        EnumMember = ' Enum',
        Event = ' Event',
        Field = 'ﰠ Field',
        File = ' File',
        Folder = ' Directory',
        Function = ' Function',
        Interface = ' Interface',
        Keyword = ' Key',
        Method = ' Method',
        Module = ' Module',
        Operator = ' Operator',
        Property = 'ﰠ Property',
        Reference = ' Reference',
        Snippet = ' Snippet',
        Struct = 'פּ Struct',
        Text = ' Text',
        TypeParameter = '',
        Unit = '塞 Unit',
        Value = ' Value',
        Variable = ' Variable',
      },
    },
  }

  vim.call('ddc#custom#patch_global', {
    autoCompleteDelay = 100,
    overwriteCompleteopt = false,
    backspaceCompletion = true,
    smartCase = true,
    sources = sources,
    sourceOptions = sourceOptions,
    sourceParams = sourceParams,
  })

  -- Markdown FileType completion sources
  vim.call('ddc#custom#patch_filetype', 'markdown', { sources = { 'around', 'buffer' } })

  -- Insert selected completion item and close menu
  vim.keymap.set('i', '<C-y>', function()
    return confirm_completion('<C-y>')
  end, { expr = true, desc = 'Insert selected completion item and close menu' })

  -- Manually open the completion menu
  vim.keymap.set(
    'i',
    '<C-Space>',
    'ddc#map#manual_complete()',
    { expr = true, desc = 'Manually open the completion menu' }
  )

  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.g.user.event,
    callback = enable,
    desc = 'Enable ddc by default',
  })
end

return M
