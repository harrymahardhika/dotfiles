return {
  {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.SetupOpts
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    }, -- use if you prefer nvim-web-devicons
    lazy = false,
    opts = {
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
    },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
}
