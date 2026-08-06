local use = require("plugin-util").use

return use("tokyonight", "folke/tokyonight.nvim", {
  pack = "start",
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
      on_highlights = function(hl, colors)
        hl.MiniIndentscopeSymbol = { fg = colors.bg_highlight }
        hl.StatusLine = { bg = "none" }
        hl.StatusLineNC = { bg = "none" }
        hl.WinBar = { bg = "none" }
        hl.WinBarNC = { bg = "none" }
        hl.SignColumn = { bg = "none" }
        hl.LineNr = { bg = "none" }
        hl.CursorLineNr = { bg = "none" }
        hl.NormalNC = { bg = "none" }
        hl.FloatBorder = { bg = "none" }
        hl.FloatTitle = { bg = "none" }
      end,
    })

    vim.cmd.colorscheme("tokyonight-night")
  end,
})
