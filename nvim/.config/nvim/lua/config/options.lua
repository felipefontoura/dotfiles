-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Add Portuguese (Brazil) to spell checking languages
vim.cmd("set spelllang=en,pt,pt_br")
vim.cmd("set spell")

-- Enable spell checking for markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
