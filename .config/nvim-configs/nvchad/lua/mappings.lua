require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-j>", "10jzz")
map("n", "<C-k>", "10kzz")
map("n", "<C-s>", ":w<CR>")
map("n", "<leader>w", ":%s/\\s\\+$//e<cr>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
