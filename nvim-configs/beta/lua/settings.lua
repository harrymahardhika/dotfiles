local o = vim.opt
local g = vim.g

o.autochdir = false
o.autoread = true
o.backspace = "indent,eol,start"
o.backup = false
o.breakindent = true
o.clipboard = "unnamedplus"
o.cmdheight = 0
o.cursorline = false
o.errorbells = false
o.expandtab = true
o.foldcolumn = "0"
o.hlsearch = false
o.number = true
o.relativenumber = true
o.shiftwidth = 2
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 2
o.termguicolors = true
o.timeoutlen = 500
o.title = true
o.ttimeoutlen = 0
o.winborder = "rounded"
o.wrap = false

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
