-- remove trailing whitespace and reformat before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*", -- Apply to all files
  command = ":%s/\\s\\+$//e", -- Remove trailing whitespace
})

-- auto-reload files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- set php commentstring to use double-slash comments
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.bo.commentstring = "// %s" -- Use double-slash comments by default
  end,
})

-- set cmdheight to 1 when recording macros
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})

-- set cmdheight to 0 when leaving recording macros
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

vim.api.nvim_create_user_command("BufOnly", function()
  vim.cmd("silent! %bd | e# | bd#")
end, {})
