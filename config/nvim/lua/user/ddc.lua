local M = {}

local function expand_snippet()
  local completeditem = vim.api.nvim_get_var('pum#completed_item')

  if completeditem.__sourceName == 'ultisnips' and vim.call('UltiSnips#CanExpandSnippet') == 1 then
    vim.call('UltiSnips#ExpandSnippet')
  end
end

local function autoimport_nvim_lsp(buf)
  local completeditem = vim.api.nvim_get_var('pum#completed_item')
  local active_clients = vim.lsp.get_active_clients({ bufnr = buf })

  if completeditem.__sourceName == 'nvim-lsp' then
    for _, client in pairs(active_clients) do
      if
        client.server_capabilities.completionProvider
        and client.server_capabilities.completionProvider.resolveProvider
        and completeditem.user_data
        and completeditem.user_data.lspitem
      then
        -- Only if there is lspitem property inside g:pum#completed_item
        -- we parse the json data
        local lspitem = completeditem.user_data.lspitem
        local completed_item = vim.fn.json_decode(lspitem)

        -- Apply text edits if it's available
        local resolve_fn = function(_, response)
          if response and response.additionalTextEdits then
            vim.lsp.util.apply_text_edits(response.additionalTextEdits, buf, 'utf-8')
          end
        end

        client.request('completionItem/resolve', completed_item, resolve_fn, buf)
        break
      end
    end
  end
end

---Register autoimporting feature from LSP server routed to pum.vim
---@param ev table
---@return nil
local function on_pum_completion(ev)
  expand_snippet()
  autoimport_nvim_lsp(ev.buf)
end

---Register events related to ddc.vim/pum.vim
---@return nil
local function register_events()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.g.user.event,
    callback = function()
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'NONE' })
    end,
    desc = 'Transparent bg for completion menu',
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PumCompleteDone',
    group = vim.g.user.event,
    callback = on_pum_completion,
    desc = 'Autoimport/Expand snippet via pum.vim',
  })
end

---Register keymaps related to ddc.vim/pum.vim
---@return nil
local function register_keymaps()
  vim.keymap.set('i', '<C-n>', '<Cmd>call pum#map#insert_relative(1)<CR>')
  vim.keymap.set('i', '<C-p>', '<Cmd>call pum#map#insert_relative(-1)<CR>')
  vim.keymap.set('i', '<C-e>', '<Cmd>call pum#map#cancel()<CR>')
  vim.keymap.set('i', '<C-y>', '<Cmd>call pum#map#confirm()<CR>')

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
    sources = { 'nvim-lsp', 'around', 'buffer', 'ultisnips' },
    autoCompleteDelay = 100,
    backspaceCompletion = true,
    ui = 'pum',
    sourceOptions = {
      ['_'] = {
        matchers = { 'matcher_fuzzy' },
        sorters = { 'sorter_fuzzy' },
        converters = { 'converter_fuzzy' },
      },
      ['nvim-lsp'] = {
        mark = 'LS',
        forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        maxItems = 10,
        ignoreCase = true,
        minAutoCompleteLength = 1,
        converters = { 'converter_kind_labels' },
      },
      ultisnips = {
        mark = 'S',
        maxItems = 5,
        ignoreCase = true,
      },
      around = {
        mark = 'A',
        maxItems = 5,
        ignoreCase = true,
      },
      buffer = {
        mark = 'B',
        maxItems = 5,
        ignoreCase = true,
      },
    },
    filterParams = {
      converter_kind_labels = {
        kindLabels = {
          Class = '󰠱 Cass',
          Color = '󱥚 Color',
          Constant = '󰏿 Const',
          Constructor = ' New',
          Enum = ' Enum',
          EnumMember = ' Enum',
          Event = ' Event',
          Field = '󰜢 Field',
          File = '󰈙 File',
          Folder = '󰉋 Dir',
          Function = '󰊕 Func',
          Interface = ' Interface',
          Keyword = '󰌆 Key',
          Method = '  Method',
          Module = ' Mod',
          Operator = '󰆕 Op',
          Property = '󰜢 Prop',
          Reference = '󰈇 Ref',
          Snippet = ' Snip',
          Struct = '󰙅 Struct',
          Text = '󰉿 Text',
          TypeParameter = '',
          Unit = ' Unit',
          Value = '󰎠 Value',
          Variable = '󰫧 Var',
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
    max_width = 80,
  })

  register_keymaps()
  register_events()

  vim.call('ddc#enable')

  vim.g.signature_help_config = {
    border = true,
    contentsStyle = 'labels',
    maxwidth = 80,
  }

  vim.call('signature_help#enable')
end

return M
