return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    -- { "<leader>n",  ":Neotree focus<CR>" },
    -- { "<leader>nf", ":Neotree float<CR>" },
    -- { "<leader>nr", ":Neotree reveal<CR>" },
    { "<leader>n", ":Neotree toggle<CR>" },
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "right",
      },
    })
  end
}
