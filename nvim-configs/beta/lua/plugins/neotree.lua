return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  keys = {
    { "<leader>e",  ":Neotree toggle<CR>",  { desc = "Toggle Neotree" } },
    { "<leader>nc", ":Neotree current<CR>", { desc = "Neotree current" } },
    { "<leader>nf", ":Neotree focus<CR>",   { desc = "Neotree focus" } },
    { "<leader>nr", ":Neotree reveal<CR>",  { desc = "Neotree reveal" } },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
    },
    window = {
      position = "float",
    }
  },
}
