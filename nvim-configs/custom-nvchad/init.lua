-- Enable vim.loader for better performance
if vim.loader then
  vim.loader.enable()
end

vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("lazy_config")

-- Load plugins
require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

-- Load settings, keymaps, autocmds, and float-term
require("settings")
require("keymaps")
require("autocmds")
require("float-term")
