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
            Pmenu = { fg = colors.text, bg = colors.surface0 },
            PmenuSel = { fg = colors.base, bg = colors.blue },
            PmenuKind = { fg = colors.subtext0, bg = colors.surface0 },
            PmenuKindSel = { fg = colors.base, bg = colors.blue },
            PmenuExtra = { fg = colors.subtext0, bg = colors.surface0 },
            PmenuExtraSel = { fg = colors.base, bg = colors.blue },
            PmenuSbar = { bg = colors.surface0 },
            PmenuThumb = { bg = colors.overlay0 },
            PmenuBorder = { fg = colors.blue, bg = colors.none },
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
