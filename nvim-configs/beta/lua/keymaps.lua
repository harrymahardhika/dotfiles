vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Command mode
-- map("n", ";", ":", { desc = "CMD enter command mode" })

-- Terminal mode
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- Scrolling with centering
map("n", "<C-j>", "10jzz", opts)
map("n", "<C-k>", "10kzz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Save
map("n", "<leader>w", ":w<CR>", { desc = "Save current file", silent = true })

-- Lazy plugin manager
map("n", "<leader>l", ":Lazy<CR>", opts)

-- Buffers
map("n", "<leader>bd", ":bd!<CR>", { desc = "Close current buffer", silent = true })
map("n", "<leader>bo", ":BufOnly<CR>", { desc = "Close all other buffers", silent = true })

-- Yank and paste with system clipboard
map({ "n", "v" }, "y", '"+y', opts)
map({ "n", "v" }, "p", '"+p', opts)

-- Commenting
map("n", "<leader>/", "gc", { desc = "Toggle comment" })

-- Oil file explorer
map("n", "-", "<cmd>Oil<CR>", { desc = "Open file explorer" })

-- jk to escape
map("i", "jk", "<Esc>", opts)

-- 💡 Optional: Remove trailing whitespace manually
map("n", "<leader>cw", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Clean trailing whitespace" })
