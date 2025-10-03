local function run_pest_with_coverage()
  local coverage_flag = "--coverage-html coverage-report"
  local original_opts = vim.g["test#php#pest#options"]

  vim.g["test#php#pest#options"] = coverage_flag
  vim.cmd("TestFile")
  vim.schedule(function()
    vim.g["test#php#pest#options"] = original_opts
  end)
end

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
      { "<leader>tc", run_pest_with_coverage, desc = "Test file with coverage" },
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
