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
    -- Get the first argument passed to Neovim
    local arg = vim.fn.argv(0)

    -- If a file is passed as an argument (e.g., during `git commit`), do nothing
    -- if arg ~= "" then
    --   return
    -- end

    -- Check if the current directory is a Git repository
    local is_git_repo = vim.fn.trim(vim.fn.system("git rev-parse --is-inside-work-tree")) == "true"

    -- If the directory is a Git repo, use git_files picker, otherwise use find_files
    if is_git_repo then
      require("telescope.builtin").git_files()
    else
      require("telescope.builtin").find_files()
    end
  end
})
