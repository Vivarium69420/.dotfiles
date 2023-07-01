local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command
-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Highlight on yanked text
autocmd("TextYankPost", {
  pattern = "*",
  command = "silent! lua vim.highlight.on_yank()",
})

-- Find and replace text in a file

