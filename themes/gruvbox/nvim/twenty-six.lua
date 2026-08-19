return {
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      transparent_mode = true,
      contrast = "medium",
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = false,
      dim_inactive = false,
      overrides = {
        StatusLine = { bg = "none" },
        StatusLineNC = { bg = "none" },
        WinBar = { bg = "none" },
        WinBarNC = { bg = "none" },
        SignColumn = { bg = "none" },
        LineNr = { bg = "none" },
        CursorLineNr = { bg = "none" },
        NormalNC = { bg = "none" },
        Pmenu = { fg = "#ebdbb2", bg = "#3c3836" },
        PmenuSel = { fg = "#282828", bg = "#fe8019" },
        PmenuKind = { fg = "#d5c4a1", bg = "#3c3836" },
        PmenuKindSel = { fg = "#282828", bg = "#fe8019" },
        PmenuExtra = { fg = "#d5c4a1", bg = "#3c3836" },
        PmenuExtraSel = { fg = "#282828", bg = "#fe8019" },
        PmenuSbar = { bg = "#3c3836" },
        PmenuThumb = { bg = "#928374" },
        PmenuBorder = { fg = "#fe8019", bg = "none" },
      },
    })

    vim.cmd.colorscheme("gruvbox")
  end,
}
