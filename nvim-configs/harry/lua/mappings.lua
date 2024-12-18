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

-- buffer navigation
-- map("n", "<Tab>", ":bnext <CR>", opts)
-- map("n", "<S-Tab>", ":bprevious <CR>", opts)
map("n", "<leader>d", ":bd! <CR>", opts)
map("n", "<leader>b", ":BufOnly <CR>", opts)

-- map("n", "<leader>e", ":Neotree focus<CR>", opts)
-- map("n", "<leader>h", ":Ex<CR>", opts)
-- map("n", "<leader>n", ":Neotree toggle<CR>", opts)
-- map("n", "<leader>pv", ":ex<CR>", opts)
