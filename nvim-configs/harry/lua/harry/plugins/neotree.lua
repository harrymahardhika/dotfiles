return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    -- { "<leader>nf", ":Neotree float<CR>" },
    { "<leader>e",  ":Neotree toggle<CR>",  { desc = "Toggle Neotree" } },
    { "<leader>nc", ":Neotree current<CR>", { desc = "Neotree current" } },
    { "<leader>nf", ":Neotree focus<CR>" },
    { "<leader>nr", ":Neotree reveal<CR>" },
  },
  config = function()
    require("neo-tree").setup({
      source_selector = {
        winbar = true,
        statusline = true,
      },
      window = {
        position = "float",
      },
    })
  end
}
