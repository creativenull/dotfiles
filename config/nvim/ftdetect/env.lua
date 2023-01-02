-- Match any .env file that has a preceding extension
-- Eg: .env.example, .env.production
vim.filetype.add({
  pattern = {
    ['.env.*'] = 'sh'
  }
})
