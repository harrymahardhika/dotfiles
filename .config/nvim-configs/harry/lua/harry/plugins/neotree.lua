return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = false,
      log_level = "warn",
      filesystem = {
        hide_dotfiles = false,
        hijack_netrw_behavior = "disabled"
      },
      follow_current_file = {
        enabled = true,
      },
      window = {
        position = "right",
      },
    })
  end
}