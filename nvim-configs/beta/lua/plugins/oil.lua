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
        max_height = 0.8,
        max_width = 0.8,
        -- preview_split = "below",
      },
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
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
