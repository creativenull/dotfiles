local M = {}

local function map(type, input, output)
    vim.api.nvim_set_keymap(type, input, output, {})
end

local function noremap(type, input, output)
    vim.api.nvim_set_keymap(type, input, output, { noremap = true })
end

function M.nnoremap(input, output) noremap('n', input, output) end

function M.inoremap(input, output) noremap('i', input, output) end

function M.vnoremap(input, output) noremap('v', input, output) end

function M.tnoremap(input, output) noremap('t', input, output) end

function M.nmap(input, output) map('n', input, output) end

function M.imap(input, output) map('i', input, output) end

function M.vmap(input, output) map('v', input, output) end

function M.tmap(input, output) map('t', input, output) end

function M.reload_config()
    for k, v in pairs(package.loaded) do
        if string.match(k, "^creativenull") then
            package.loaded[k] = nil
        end
    end

    -- TODO
    -- Find another way to re-source our init.lua
    -- outside of vim.cmd
    vim.cmd 'luafile $MYVIMRC'
end

-- Toggle Conceal for markdown, json, etc
function M.toggle_conceal()
    if vim.wo.conceallevel == 2 then
        vim.wo.conceallevel = 0
    else
        vim.wo.conceallevel = 2
    end
end

return M
