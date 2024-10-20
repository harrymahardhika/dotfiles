return {
  "vim-test/vim-test",
  lazy = true,
  dependencies = { "preservim/vimux" },
  keys = {
    {
      "<leader>t",
      ":TestNearest<CR>",
      desc = "Test nearest"
    },
    {
      "<leader>T",
      ":TestFile<CR>",
      desc = "Test file"
    },
    {
      "<leader>ta",
      ":TestSuite<CR>",
      desc = "Test suite"
    },
    {
      "<leader>tl",
      ":TestLast<CR>",
      desc = "Test last"
    },
    {
      "<leader>g",
      ":TestVisit<CR>",
      desc = "Test visit"
    },
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
