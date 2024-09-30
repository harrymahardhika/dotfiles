return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority  = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      no_italic = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        noice = true,
        notify = true,
        nvimtree = true,
        treesitter = true,
      }
    })

    vim.cmd("colorscheme catppuccin")
  end
}

