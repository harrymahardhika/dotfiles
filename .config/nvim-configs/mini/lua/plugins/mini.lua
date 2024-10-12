return {
  {
    "echasnovski/mini.nvim",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    config = function()
      require("mini.ai").setup()
      require("mini.icons").setup()
      require("mini.indentscope").setup({
        vim.keymap.set("n", "<leader>b", "<cmd>:Pick buffers<CR>", {})
      })
      require("mini.notify").setup()
      require("mini.pick").setup()
      require("mini.statusline").setup()
    end
  }
}
