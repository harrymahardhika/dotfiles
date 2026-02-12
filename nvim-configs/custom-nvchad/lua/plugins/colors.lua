return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = false, -- Disabled by default since NvChad uses base46
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = false,
      float = {
        transparent = false,
        solid = false,
      },
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
        treesitter = true,
        which_key = true,
      },
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
