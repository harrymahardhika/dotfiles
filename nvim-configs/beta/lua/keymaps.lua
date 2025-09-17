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
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current and vim.bo[buf].buftype ~= "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Close all other buffers except terminals", silent = true })

-- Yank and paste with system clipboard
-- map({ "n", "v" }, "y", '"+y', opts)
-- map({ "n", "v" }, "p", '"+p', opts)

-- Commenting
map("n", "<leader>/", "gc", { desc = "Toggle comment" })

-- Oil file explorer
map("n", "-", "<cmd>Oil<CR>", { desc = "Open file explorer" })

-- jk to escape
map("i", "jk", "<Esc>", opts)

-- Remove trailing whitespace manually
map("n", "<leader>cw", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Clean trailing whitespace" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Previous diagnostic" })

-- Quickfix list navigation
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next Quickfix" })

-- Copy file paths to clipboard
local function copy_to_clipboard(label, value)
  vim.fn.setreg("+", value)
  vim.notify("📋 Copied " .. label .. ": " .. value, vim.log.levels.INFO, { title = "Copy Path" })
end

vim.keymap.set("n", "<leader>cf", function()
  copy_to_clipboard("full path", vim.fn.expand("%:p"))
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>cr", function()
  copy_to_clipboard("relative path", vim.fn.expand("%"))
end, { desc = "Copy relative file path" })

vim.keymap.set("n", "<leader>cn", function()
  copy_to_clipboard("file name", vim.fn.expand("%:t"))
end, { desc = "Copy file name" })

vim.keymap.set("n", "<leader>ce", function()
  copy_to_clipboard("file name (no ext)", vim.fn.expand("%:t:r"))
end, { desc = "Copy file name without extension" })

vim.keymap.set("n", "<leader>cd", function()
  copy_to_clipboard("directory", vim.fn.expand("%:p:h"))
end, { desc = "Copy directory path" })
