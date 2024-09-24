-- Autocmd to remove trailing whitespace before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",  -- Apply to all files
  command = ":%s/\\s\\+$//e",  -- Remove trailing whitespace
})

-- auto-reload files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
