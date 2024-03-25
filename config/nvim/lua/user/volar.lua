local M = {}

local matches = { 'components.d.ts', 'auto-imports.d.ts' }

local function result_match(results)
  for _, res in pairs(results) do
    for _, fname in pairs(matches) do
      if vim.endswith(res.targetUri, fname) then
        return res
      end
    end
  end

  return nil
end

local function open_filename(targetUri_fname, matched_fname)
  local target_fname = string.format('%s/%s', vim.fs.dirname(targetUri_fname), matched_fname)

  if vim.endswith(target_fname, '.vue') then
    vim.cmd(string.format('edit %s', target_fname))
  else
    -- Assume it's a js/ts filename instead
    local ext = '.js'
    if vim.fn.filereadable(target_fname .. ext) == 0 then
      ext = '.ts'
    end

    vim.cmd(string.format('edit %s%s', target_fname, ext))
  end
end

function M.create_definition(default_cb)
  return function(err, results, ctx, config)
    if err or results == nil or vim.tbl_isempty(results) then
      return
    end

    local res = result_match(results)
    if res == nil then
      default_cb(err, results, ctx, config)
      return
    end

    local fname = vim.uri_to_fname(res.targetUri)
    local sline = res.targetRange.start.line
    local contents = vim.fn.readfile(fname)
    local content_line = vim.trim(contents[sline + 1])
    local matched_filename = vim.fn.matchlist(content_line, 'typeof import([\'"]\\(\\.*/.*\\)[\'"])')

    if not vim.tbl_isempty(matched_filename) then
      open_filename(fname, matched_filename[2])
      return
    end

    -- Always default to builtin behavior, if anything fails
    default_cb(err, results, ctx, config)
  end
end

return M
