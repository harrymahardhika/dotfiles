require "nvchad.options"

local o = vim.opt
local g = vim.g

-- Custom settings from beta config
o.relativenumber = true
o.cmdheight = 0
o.cursorline = false
o.hlsearch = false
o.timeoutlen = 300
o.winborder = "rounded"
o.wrap = false

-- Netrw settings
g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Clipboard provider for Wayland
g.clipboard = {
  name = "WaylandClipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = 1,
}

-- Diagnostics with rounded borders
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
