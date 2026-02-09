return {
  "nvchad/base46",
  lazy = false,
  priority = 999, -- Load before UI but after catppuccin
  config = function()
    -- Load base46 and compile theme
    local base46 = require("base46")
    base46.load_all_highlights()
    
    -- Load compiled highlights (only defaults, no statusline)
    dofile(vim.g.base46_cache .. "defaults")
  end,
}
