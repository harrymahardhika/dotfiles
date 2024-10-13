return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        no_italic = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          mini = {
            enabled = true,
            indentscope_color = "surface0",
          },
          noice = true,
          notify = true,
          nvimtree = true,
          treesitter = true,
        }
      })

      vim.cmd("colorscheme catppuccin")
    end
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     -- vim.cmd("colorscheme tokyonight-moon")
  --     -- vim.cmd("colorscheme tokyonight-night")
  --     vim.cmd("colorscheme tokyonight-storm")
  --   end
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd("colorscheme gruvbox")
  --   end
  -- }
}
