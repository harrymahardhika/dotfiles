return {
  "karb94/neoscroll.nvim",
  opts = {
    mappings = {
      "<C-u>",
      "<C-d>",
      "<C-b>",
      "<C-f>",
      "<C-y>",
      "<C-e>",
      "zt",
      "zz",
      "zb",
    },
    duration_multiplier = 150 / 250,
  },
  config = function(_, opts)
    local neoscroll = require("neoscroll")
    neoscroll.setup(opts)

    local duration = 150

    local function scroll_with_center(lines)
      neoscroll.scroll(lines, {
        move_cursor = true,
        duration = duration,
      })

      vim.cmd("normal! zz")
    end

    vim.keymap.set("n", "go", function()
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      scroll_with_center(-(current_line - 1))
    end, { desc = "Neoscroll to file top", silent = true })

    vim.keymap.set("n", "gg", function()
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      scroll_with_center(-(current_line - 1))
    end, { desc = "Neoscroll go to top and center", silent = true })

    vim.keymap.set("n", "G", function()
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      local last_line = vim.api.nvim_buf_line_count(0)
      scroll_with_center(last_line - current_line)
    end, { desc = "Neoscroll go to bottom and center", silent = true })

    vim.keymap.set("n", "<C-j>", function()
      scroll_with_center(10)
    end, { desc = "Neoscroll down 10 lines and center", silent = true })

    vim.keymap.set("n", "<C-k>", function()
      scroll_with_center(-10)
    end, { desc = "Neoscroll up 10 lines and center", silent = true })
  end,
}
