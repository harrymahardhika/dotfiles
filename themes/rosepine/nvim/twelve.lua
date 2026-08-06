local use = require("plugin-util").use

return use("rose-pine", "rose-pine/neovim", {
  pack = "start",
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
})
