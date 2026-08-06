return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      variant = "main",
      styles = {
        bold = true,
        italic = false,
        transparency = true,
      },
      highlight_groups = {
        MiniIndentscopeSymbol = { fg = "overlay" },
        WinBar = { bg = "NONE" },
        WinBarNC = { bg = "NONE" },
        LineNr = { bg = "NONE" },
        CursorLineNr = { bg = "NONE" },
        FloatBorder = { fg = "pine", bg = "NONE" },
        TelescopeBorder = { fg = "pine", bg = "NONE" },
        TelescopeTitle = { fg = "pine", bg = "NONE" },

        -- Default pmenu.bg/bg_sel are overlay/highlightMed, which clash with
        -- the pine accent used elsewhere; restyle the completion/wildmenu
        -- popup to match.
        Pmenu = { fg = "text", bg = "overlay" },
        PmenuSel = { fg = "base", bg = "pine" },
        PmenuKind = { fg = "subtle", bg = "overlay" },
        PmenuKindSel = { fg = "base", bg = "pine" },
        PmenuExtra = { fg = "subtle", bg = "overlay" },
        PmenuExtraSel = { fg = "base", bg = "pine" },
        PmenuSbar = { bg = "overlay" },
        PmenuThumb = { bg = "muted" },
        PmenuBorder = { fg = "pine", bg = "NONE" },
      },
      -- WinBarNC defaults to a panel bg with blend=60; drop the blend so the
      -- NONE override stays transparent instead of being blended into base.
      before_highlight = function(group, highlight)
        if group == "WinBar" or group == "WinBarNC" then
          highlight.blend = nil
        end
      end,
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
