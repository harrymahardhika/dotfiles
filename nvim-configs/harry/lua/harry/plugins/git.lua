return {
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { desc = "diff_this" })
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset_buffer" })
          map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage_buffer" })
          map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "blame_line" })
          map("n", "<leader>hd", gitsigns.diffthis, { desc = "diffthis" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "preview_hunk" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset_hunk" })
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage_hunk" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "undo_stage_hunk" })
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle_current_line_blame" })
          map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "toggle_deleted" })
          map("v", "<leader>hr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
            { desc = "reset_hunk" })
          map("v", "<leader>hs", function() gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
            { desc = "stage_hunk" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end
      })
    end
  }
}
