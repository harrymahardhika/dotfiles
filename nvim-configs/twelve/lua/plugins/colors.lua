local use = require("plugin-util").use

return use("catppuccin", "catppuccin/nvim", {
  pack = "start",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      auto_integrations = true,
      flavour = "mocha",
      transparent_background = true,
      float = {
        transparent = true,
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
        which_key = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
})
