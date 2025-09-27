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

    local function do_scroll(lines)
      local target_win = vim.api.nvim_get_current_win()
      local target_buf = vim.api.nvim_get_current_buf()
      local wait = duration

      if lines ~= 0 then
        neoscroll.scroll(lines, {
          move_cursor = true,
          duration = duration,
          winid = target_win,
        })
      else
        wait = 0
      end

      -- Recenter smoothly with neoscroll once the jump finishes.
      vim.defer_fn(function()
        if not vim.api.nvim_win_is_valid(target_win) then
          return
        end
        if vim.api.nvim_win_get_buf(target_win) ~= target_buf then
          return
        end

        vim.api.nvim_win_call(target_win, function()
          neoscroll.zz({
            half_win_duration = duration,
            winid = target_win,
          })
        end)
      end, wait)
    end

    vim.keymap.set("n", "go", function()
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      do_scroll(-(current_line - 1))
    end, { desc = "Neoscroll to file top", silent = true })

    vim.keymap.set("n", "gg", function()
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      do_scroll(-(current_line - 1))
    end, { desc = "Neoscroll go to top", silent = true })

    vim.keymap.set("n", "G", function()
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      local last_line = vim.api.nvim_buf_line_count(0)
      do_scroll(last_line - current_line)
    end, { desc = "Neoscroll go to bottom", silent = true })

    vim.keymap.set("n", "<C-j>", function()
      do_scroll(10)
    end, { desc = "Neoscroll down 10 lines", silent = true })

    vim.keymap.set("n", "<C-k>", function()
      do_scroll(-10)
    end, { desc = "Neoscroll up 10 lines", silent = true })
  end,
}
