vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


map("n", ";", ":", { desc = "CMD enter command mode" })
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

map("n", "<C-j>", "10jzz", opts)
map("n", "<C-k>", "10kzz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

map("n", "<leader>w", ":w<CR>", { desc = "Save current file", nowait = true })

map("n", "<leader>l", ":Lazy<CR>", opts)

map("n", "<leader>bd", ":bd! <CR>", { desc = "Close current buffer" })
map("n", "<leader>bo", ":BufOnly <CR>", { desc = "Close all other buffers" })

-- Yank to system clipboard
map("n", "y", '"+y', opts)
map("v", "y", '"+y', opts)

-- Paste from system clipboard
map("n", "p", '"+p', opts)
map("v", "p", '"+p', opts)

map("n", "<leader>/", "gc", { desc = "Toggle comment" })
map("n", "-", "<cmd>Oil<CR>", { desc = "Open file explorer" })

map("i", "jk", "<Esc>", { noremap = true, silent = true })
