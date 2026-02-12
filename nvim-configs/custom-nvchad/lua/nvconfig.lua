---@type NvConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,

  hl_override = {
    Comment = { italic = false },
    ["@comment"] = { italic = false },
    EndOfBuffer = { fg = "NONE", bg = "NONE" }, -- Hide ~ for empty buffers
    StatusLine = { bg = "NONE" }, -- Transparent statusline background
    StatusLineNC = { bg = "NONE" }, -- Transparent non-current statusline background
  },

  hl_add = {},
  integrations = {},
  changed_themes = {},
}

M.ui = {
  cmp = {
    icons_left = true,
    style = "default",
  },
  telescope = { style = "borderless" },

  statusline = {
    enabled = false,
  },

  tabufline = {
    enabled = false,
  },
}

M.colorify = {
  enabled = false,
  mode = "virtual",
}

M.nvdash = {
  load_on_startup = false,
  header = {},
  buttons = {},
}

M.cheatsheet = {
  theme = "grid",
  excluded_groups = {},
}

M.lsp = { signature = true }

M.term = {
  winopts = { winhl = "Normal:term,WinSeparator:WinSeparator" },
  sizes = { sp = 0.3, vsp = 0.4, ["bo sp"] = 0.3, ["bo vsp"] = 0.4 },
  float = {
    relative = "editor",
    row = 0.1,
    col = 0.1,
    width = 0.8,
    height = 0.7,
    border = "rounded",
  },
}

return M
