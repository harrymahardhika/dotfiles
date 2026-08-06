return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
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
        hl.NormalFloat = { bg = "none" }
        hl.FloatBorder = { fg = colors.blue, bg = "none" }
        hl.TelescopeBorder = { fg = colors.blue, bg = "none" }
        hl.TelescopeTitle = { fg = colors.blue, bg = "none" }
        hl.FloatTitle = { bg = "none" }

        -- Default pmenu.bg/bg_sel are bg_highlight/bg_dark, which clash with
        -- the blue accent used elsewhere; restyle the completion/wildmenu
        -- popup to match.
        hl.Pmenu = { fg = colors.fg, bg = colors.bg_highlight }
        hl.PmenuSel = { fg = colors.bg, bg = colors.blue }
        hl.PmenuKind = { fg = colors.fg_dark, bg = colors.bg_highlight }
        hl.PmenuKindSel = { fg = colors.bg, bg = colors.blue }
        hl.PmenuExtra = { fg = colors.fg_dark, bg = colors.bg_highlight }
        hl.PmenuExtraSel = { fg = colors.bg, bg = colors.blue }
        hl.PmenuSbar = { bg = colors.bg_highlight }
        hl.PmenuThumb = { bg = colors.fg_gutter }
        hl.PmenuBorder = { fg = colors.blue, bg = "none" }
      end,
    })

    vim.cmd("colorscheme tokyonight-night")
  end,
}
