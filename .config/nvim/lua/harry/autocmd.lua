-- Autocmd to remove trailing whitespace before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",  -- Apply to all files
  command = ":%s/\\s\\+$//e",  -- Remove trailing whitespace
})
