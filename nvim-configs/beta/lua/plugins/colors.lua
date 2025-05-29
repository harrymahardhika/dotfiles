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
          copilot_vim = true,
          gitsigns = true,
          grug_far = true,
          mini = {
            enabled = true,
            indentscope_color = "surface0",
          },
          noice = true,
          notify = true,
          nvimtree = true,
          neotree = true,
          treesitter = true,
        }
      })

      vim.cmd("colorscheme catppuccin")
    end
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "moon", -- "storm", "night", "day"
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = {},
        functions = {},
        keywords = {},
        variables = {},
      },
    },
    config = function()
      -- vim.cmd.colorscheme("tokyonight")
    end
  },
}
