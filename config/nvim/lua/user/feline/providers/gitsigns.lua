local M = {}

function M.has_changes(attr)
  local buf = vim.api.nvim_get_current_buf()

  if vim.b[buf].gitsigns_status_dict ~= nil then
    local git_status = vim.b[buf].gitsigns_status_dict

    if attr == "added" or attr == "changed" or attr == "removed" then
      return git_status[attr] ~= nil and git_status[attr] > 0 or false
    end
  end

  return false
end

function M.has_branch()
  local buf = vim.api.nvim_get_current_buf()
  return vim.b[buf].gitsigns_head ~= nil
end

function M.gitsigns_status_provider(component)
  if component.enabled == nil then
    component.enabled = function()
      return M.has_branch()
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  local head = vim.b[buf].gitsigns_head

  if head == nil then
    return ""
  end

  return string.format(" 󰘬 %s ", head)
end

function M.gitsigns_added_provider(component)
  local prefix_icon = "+"
  local key = "added"
  if component.enabled == nil then
    component.enabled = function()
      return M.has_changes(key)
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  local dict = vim.b[buf].gitsigns_status_dict or { [key] = 0 }

  if dict[key] == 0 then
    return ""
  end

  return string.format("%s%s", prefix_icon, dict[key])
end

function M.gitsigns_changed_provider(component)
  local prefix_icon = "~"
  local key = "changed"
  if component.enabled == nil then
    component.enabled = function()
      return M.has_changes(key)
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  local dict = vim.b[buf].gitsigns_status_dict or { [key] = 0 }

  if dict[key] == 0 then
    return ""
  end

  return string.format("%s%s", prefix_icon, dict[key])
end

function M.gitsigns_removed_provider(component)
  local prefix_icon = "-"
  local key = "removed"
  if component.enabled == nil then
    component.enabled = function()
      return M.has_changes(key)
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  local dict = vim.b[buf].gitsigns_status_dict or { [key] = 0 }

  if dict[key] == 0 then
    return ""
  end

  return string.format("%s%s", prefix_icon, dict[key])
end

return M
