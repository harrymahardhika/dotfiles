return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus NvimTree" },
  },
  opts = {
    view = {
      side = "right",
      width = 35,
    },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },
    filters = {
      dotfiles = false,
      custom = { "^.git$", "node_modules" },
    },
    git = {
      enable = true,
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
  },
}
