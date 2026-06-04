if vim.loader then
  vim.loader.enable()
end

local init_file = debug.getinfo(1, "S").source:sub(2)
local config_root = vim.fs.dirname(init_file)
vim.opt.rtp:prepend(config_root)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("settings")
require("keymaps")
require("autocmds")
require("float-term")
require("treesitter")
require("pack").setup()
