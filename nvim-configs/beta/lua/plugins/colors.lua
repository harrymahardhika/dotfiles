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
        }
      })

      vim.cmd("colorscheme catppuccin")
    end
  }
}
