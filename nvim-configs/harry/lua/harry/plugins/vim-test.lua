return {
  "vim-test/vim-test",
  dependencies = { "preservim/vimux" },
  keys = {
    { "<leader>t",  ":TestNearest<CR>" },
    { "<leader>T",  ":TestFile<CR>" },
    { "<leader>ta", ":TestSuite<CR>" },
    { "<leader>tl", ":TestLast<CR>" },
    { "<leader>g",  ":TestVisit<CR>" },
  },
  config = function()
    -- vim.cmd("let test#strategy = 'neovim'")
    -- vim.cmd("let g:test#neovim#start_normal = 1")

    vim.cmd("let test#strategy = 'kitty'")

    -- vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
    -- vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
    -- vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", {})
    -- vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", {})
    -- vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
  end
}
