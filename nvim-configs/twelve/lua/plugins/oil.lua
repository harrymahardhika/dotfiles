local use = require("plugin-util").use

return {
  use("oil.nvim", "stevearc/oil.nvim", {
    pack = "start",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("oil").setup({
        float = {
          max_height = 0.7,
          max_width = 0.7,
        },
        view_options = {
          show_hidden = true,
        },
        win_options = {
          number = false,
          relativenumber = false,
          statuscolumn = "",
          signcolumn = "yes:2",
          conceallevel = 3,
          concealcursor = "nvic",
        },
      })
    end,
  }),
  use("oil-git-status.nvim", "refractalize/oil-git-status.nvim", {
    pack = "start",
    dependencies = { "oil.nvim" },
    config = function()
      require("oil-git-status").setup({})
    end,
  }),
}
