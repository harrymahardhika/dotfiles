return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        float = {
          transparent = true,
          solid = false,
        },
        no_italic = true,
        integrations = {
          blink_cmp = {
            style = "bordered",
          },
          cmp = true,
          copilot_vim = true,
          flash = true,
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
          which_key = true,
        },
      })

      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          functions = { italic = false },
          variables = { italic = false },
        },
      })

      -- vim.cmd("colorscheme tokyonight")
    end,
  },
}
