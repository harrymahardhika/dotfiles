local o = vim.opt
local g = vim.g

o.autochdir = false
o.autoindent = true
o.autoread = true
o.backspace = "indent,eol,start"
o.backup = false
o.breakindent = true
o.clipboard = "unnamedplus"
o.cmdheight = 0
o.encoding = "utf-8"
o.errorbells = false
o.expandtab = true
o.fileencoding = "utf-8"
o.foldcolumn = "0"
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.hlsearch = false
o.incsearch = true
o.number = true
o.relativenumber = true
o.scrolloff = 10
o.shiftwidth = 2
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.smarttab = true
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 2
o.termguicolors = true
o.timeoutlen = 500
o.title = true
o.ttimeoutlen = 0
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
