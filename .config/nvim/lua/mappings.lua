vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<leader>pv", ":Ex<CR>", opts)
map("n", "<leader>h", ":Ex<CR>", opts)
map("n", "<leader>l", ":Lazy<CR>", opts)
map("n", "<C-s>", ":w<CR>", opts)

