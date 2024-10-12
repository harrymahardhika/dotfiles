vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-j>", "10jzz", opts)
map("n", "<C-k>", "10kzz", opts)
map("n", "<C-s>", ":w<CR>", opts)
map("n", "<leader>l", ":Lazy<CR>", opts)
map("n", "<leader>w", ":%s/\\s\\+$//e<CR>", opts)

-- map("n", "<leader>e", ":Neotree focus<CR>", opts)
-- map("n", "<leader>h", ":Ex<CR>", opts)
-- map("n", "<leader>n", ":Neotree toggle<CR>", opts)
-- map("n", "<leader>pv", ":ex<CR>", opts)
