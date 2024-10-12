-- remove trailing whitespace and reformat before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",              -- Apply to all files
  command = ":%s/\\s\\+$//e", -- Remove trailing whitespace
})

-- auto-reload files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)

    local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):match("true")

    if is_git_repo then
      -- If it's a Git repo, use git_files picker
      require("telescope.builtin").git_files()
    else
      -- If not a Git repo, use find_files picker
      require("telescope.builtin").find_files()
    end
  end
})
