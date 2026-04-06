-- Enable vim.loader for better performance
if vim.loader then
  vim.loader.enable()
end

-- Set leader keys at the very beginning
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable unnecessary providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins with the performance configuration
local lazy_config = require("lazy_config")

require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

-- Load the rest of the configuration
require("settings")
require("keymaps")
require("autocmds")
require("float-term")
