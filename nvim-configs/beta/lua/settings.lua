local o = vim.opt
local g = vim.g

-- Performance optimizations
o.lazyredraw = true -- Don't redraw during macros
o.synmaxcol = 0 -- Highlight all columns (avoid partial/wrong colors on long lines)
o.redrawtime = 1500 -- Timeout for syntax highlighting (ms)

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
o.foldenable = true
o.foldlevelstart = 99
o.hlsearch = false
o.number = false
o.relativenumber = false
o.scrolloff = 8
o.shiftwidth = 2
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 2
o.termguicolors = true
o.timeoutlen = 300
o.title = true
o.ttimeoutlen = 10
o.undofile = true
o.updatetime = 250
o.winborder = "rounded"
o.wrap = false
o.pumheight = 10
o.conceallevel = 2
o.confirm = true

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

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
  -- Performance: Update diagnostics in insert mode less frequently
  update_in_insert = false,
})
