-- Autocmd to remove trailing whitespace and reformat before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*", -- Apply to all files
  -- command = ":%s/\\s\\+$//e",  -- Remove trailing whitespace

  callback = function(args)
    vim.api.nvim_exec([[
      %s/\s\+$//e
    ]], false)

    require("conform").format({ bufnr = args.buf })
  end,
})

-- auto-reload files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
