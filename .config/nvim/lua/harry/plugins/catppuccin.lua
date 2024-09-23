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
        nvimtree = true,
        treesitter = true,
        noice = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      }
    })

    vim.cmd("colorscheme catppuccin")
  end
}

