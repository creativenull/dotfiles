vim.keymap.set("n", "gf", function()
  local dotpath = vim.fn.expand("<cword>")
  local context = vim.fn.expand("<cWORD>")
  local path, filename = "", ""

  if vim.startswith(context, "view") or vim.startswith(context, "View::make") then
    -- Ex:
    --    view('welcome') -> :e resources/views/welcome.blade.php
    --    view('layouts.app') -> :e resources/views/layouts/app.blade.php
    path = string.gsub(dotpath, "%.", "/")
    filename = string.format("resources/views/%s.blade.php", path)
  elseif vim.startswith(context, "config") then
    -- Ex:
    --    config('app.name') -> :e config/app.php
    --    config('broadcasting.default') -> :e config/broadcasting.php
    path = vim.split(dotpath, "%.", { trimempty = true })[1]
    filename = string.format("config/%s.php", path)
  end

  if filename ~= "" then
    vim.cmd(string.format("edit %s", filename))
  end
end, { silent = true })

vim.opt_local.iskeyword:append("-")
vim.opt_local.iskeyword:append(".")
