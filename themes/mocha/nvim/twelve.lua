local use = require("plugin-util").use

return use("catppuccin", "catppuccin/nvim", {
  pack = "start",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      auto_integrations = false,
      flavour = "mocha",
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
      no_italic = true,
      highlight_overrides = {
        all = function(colors)
          return {
            StatusLine = { bg = colors.none },
            StatusLineNC = { bg = colors.none },
            WinBar = { bg = colors.none },
            WinBarNC = { bg = colors.none },
            SignColumn = { bg = colors.none },
            LineNr = { bg = colors.none },
            CursorLineNr = { bg = colors.none },
            NormalNC = { bg = colors.none },
          }
        end,
      },
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
