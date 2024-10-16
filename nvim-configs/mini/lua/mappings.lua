vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-j>", "10jzz", opts)
map("n", "<C-k>", "10kzz", opts)
map("n", "<C-s>", ":w<CR>", opts)
map("n", "<leader>l", ":Lazy<CR>", opts)
map("n", "<leader>w", ":%s/\\s\\+$//e<CR>", opts)

-- window split navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)

-- buffer navigation
map("n", "<Tab>", ":bnext <CR>", opts)
map("n", "<S-Tab>", ":bprevious <CR>", opts)
map("n", "<leader>d", ":bd! <CR>", opts)

-- netrw
map("n", "<leader>e", ":25Lex<CR>", opts)

-- mini.pick
map("n", "<leader>ff", function() require("mini.pick").builtin.files() end)
map("n", "<leader>fe", function() require("mini.pick").builtin.buffers() end)

map("n", "gd", function() vim.lsp.buf.definition() end, { desc = 'Go To Definition' })

-- map("n", "<leader>e", ":Neotree focus<CR>", opts)
-- map("n", "<leader>h", ":Ex<CR>", opts)
-- map("n", "<leader>n", ":Neotree toggle<CR>", opts)
-- map("n", "<leader>pv", ":ex<CR>", opts)
