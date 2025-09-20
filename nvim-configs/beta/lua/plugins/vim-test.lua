return {
  {
    "vim-test/vim-test",
    lazy = true,
    dependencies = { "preservim/vimux" },
    keys = {
      { "<leader>tn", ":TestNearest<CR>", desc = "Test nearest" },
      { "<leader>tf", ":TestFile<CR>", desc = "Test file" },
      { "<leader>T", ":TestFile<CR>", desc = "Test file" },
      { "<leader>ta", ":TestSuite<CR>", desc = "Test suite" },
      { "<leader>tl", ":TestLast<CR>", desc = "Test last" },
      -- { "<leader>g", ":TestVisit<CR>", desc = "Test visit" },
    },
    config = function()
      -- vim.cmd("let test#strategy = 'neovim'")
      -- vim.cmd("let g:test#neovim#start_normal = 1")
      -- vim.cmd("let test#strategy = 'kitty'")
      vim.cmd("let test#strategy = 'vimux'")
    end,
  },
  {
    "preservim/vimux",
  },
}
