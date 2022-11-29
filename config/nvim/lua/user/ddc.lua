local M = {}

local sources = { 'nvim-lsp', 'around', 'buffer' }
local cmdline_sources = {
  [':'] = { 'cmdline', 'around' },
  ['@'] = { 'cmdline' },
  ['/'] = { 'around' },
  ['?'] = { 'around' },
}
local cmdline_keymaps = {
  { lhs = '<Tab>', rhs = '<Cmd>call pum#map#insert_relative(+1)<CR>' },
  { lhs = '<S-Tab>', rhs = '<Cmd>call pum#map#insert_relative(-1)<CR>' },
  { lhs = '<C-n>', rhs = '<Cmd>call pum#map#insert_relative(+1)<CR>' },
  { lhs = '<C-p>', rhs = '<Cmd>call pum#map#insert_relative(-1)<CR>' },
  { lhs = '<C-y>', rhs = '<Cmd>call pum#map#confirm()<CR>' },
  { lhs = '<C-e>', rhs = '<Cmd>call pum#map#cancel()<CR>' },
}

---Register keymaps for cmdline
---@return nil
local function set_cmdline_keymaps()
  for _, keymap in pairs(cmdline_keymaps) do
    vim.keymap.set('c', keymap.lhs, keymap.rhs)
  end
end

---Unregister keymaps for cmdline, applied on ddc leave event
---@return nil
local function unset_cmdline_keymaps()
  for _, keymap in pairs(cmdline_keymaps) do
    vim.keymap.del('c', keymap.lhs, { silent = true })
  end
end

---Callback to unregister cmdline keymaps
---@return nil
local function cmdline_post_cb()
  pcall(unset_cmdline_keymaps)

  -- Restore sources
  if vim.fn.exists('b:prev_buffer_config') == 1 then
    vim.call('ddc#custom#set_buffer', vim.b.prev_buffer_config)
    vim.b.prev_buffer_config = nil
  else
    vim.call('ddc#custom#set_buffer', vim.empty_dict())
  end
end

---Setup events to register/unregister keymaps, enable cmdline completion,
---and add cmdline sources
---@return nil
local function cmdline_pre()
  set_cmdline_keymaps()

  if vim.fn.exists('b:prev_buffer_config') == 0 then
    vim.b.prev_buffer_config = vim.call('ddc#custom#get_buffer')
  end

  vim.call('ddc#custom#patch_buffer', 'cmdlineSources', cmdline_sources)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'DDCCmdlineLeave',
    once = true,
    callback = cmdline_post_cb,
    desc = '[ddc] Unregister keymaps and restore sources',
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    pattern = '<buffer>',
    once = true,
    callback = cmdline_post_cb,
    desc = '[ddc] Unregister keymaps and restore sources',
  })

  vim.call('ddc#enable_cmdline_completion')
end

local function register_ui_events()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.g.user.event,
    callback = function()
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'NONE' })
    end,
    desc = 'No bg color for completion menu',
  })
end

local function register_keymaps()
  vim.keymap.set('i', '<C-n>', '<Cmd>call pum#map#insert_relative(1)<CR>')
  vim.keymap.set('i', '<C-p>', '<Cmd>call pum#map#insert_relative(-1)<CR>')
  vim.keymap.set('i', '<C-e>', '<Cmd>call pum#map#cancel()<CR>')
  vim.keymap.set('i', '<C-y>', function()
    vim.call('pum#map#confirm')
  end, { desc = 'Insert item from snippet or menu item' })

  vim.keymap.set('n', ':', function()
    cmdline_pre()
    vim.api.nvim_feedkeys(':', 'n', false)
  end)

  -- Manually open the completion menu
  vim.keymap.set(
    'i',
    '<C-Space>',
    'ddc#map#manual_complete()',
    { replace_keycodes = false, expr = true, desc = '[ddc.vim] Manually open popup menu' }
  )
end

function M.setup()
  vim.call('ddc#custom#patch_global', {
    sources = sources,
    cmdlineSources = cmdline_sources,
    autoCompleteEvents = { 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged' },
    autoCompleteDelay = 100,
    overwriteCompleteopt = false,
    backspaceCompletion = true,
    smartCase = true,
    completionMenu = 'pum.vim',
    ui = 'pum',
    sourceOptions = {
      ['_'] = {
        matchers = { 'matcher_fuzzy' },
        sorters = { 'sorter_fuzzy' },
        converters = { 'converter_fuzzy' },
      },
      cmdline = {
        mark = 'CMD',
        maxCandidates = 10,
        ignoreCase = true,
      },
      ['nvim-lsp'] = {
        mark = 'LS',
        forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        maxCandidates = 10,
        ignoreCase = true,
        minAutoCompleteLength = 1,
      },
      vsnip = {
        mark = 'S',
        maxCandidates = 5,
        ignoreCase = true,
      },
      around = {
        mark = 'A',
        maxCandidates = 5,
        ignoreCase = true,
      },
      buffer = {
        mark = 'B',
        maxCandidates = 5,
        ignoreCase = true,
      },
    },
    sourceParams = {
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
    },
  })

  -- Markdown FileType completion sources
  vim.call('ddc#custom#patch_filetype', 'markdown', { sources = { 'around', 'buffer' } })

  -- pum.vim Config
  -- ---
  vim.call('pum#set_option', {
    border = 'rounded',
    padding = true,
    scrollbar_char = '',
    offset_row = vim.opt.cmdheight:get() + 1, -- cmdheight + statusline height
    max_height = 15,
  })

  register_keymaps()
  register_ui_events()

  vim.call('ddc#enable')
  vim.call('signature_help#enable')
end

return M
