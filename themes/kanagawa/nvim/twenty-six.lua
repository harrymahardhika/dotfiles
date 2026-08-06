return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      transparent = true,
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
      statementStyle = { italic = false },
      functionStyle = { italic = false },
      overrides = function(colors)
        return {
          MiniIndentscopeSymbol = { fg = colors.theme.ui.bg_p2 },
          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },
          WinBar = { bg = "none" },
          WinBarNC = { bg = "none" },
          SignColumn = { bg = "none" },
          LineNr = { bg = "none" },
          CursorLineNr = { bg = "none" },
          NormalNC = { bg = "none" },
          NormalFloat = { bg = "none" },
          FloatBorder = { fg = "#938056", bg = "none" },
          FloatTitle = { bg = "none" },
        }
      end,
    })

    vim.cmd("colorscheme kanagawa")
  end,
}
