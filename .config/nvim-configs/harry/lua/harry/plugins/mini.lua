return {
  {
    "echasnovski/mini.nvim",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    config = function()
      require("mini.ai").setup()
      require("mini.clue").setup()
      require("mini.indentscope").setup()
      -- require("mini.statusline").setup()
    end
  }
}
