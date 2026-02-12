return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        current_line_blame = true,
        on_attach = function(bufnr)
          local function set_keymap(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          set_keymap("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          set_keymap("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          set_keymap("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "Diff this" })
          set_keymap("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
          set_keymap("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
          set_keymap("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Blame line" })
          set_keymap("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
          set_keymap("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
          set_keymap("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
          set_keymap("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
          set_keymap("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
          set_keymap("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          set_keymap("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })

          -- Text object
          set_keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua", -- optional
    },
    cmd = "Neogit",
    config = function()
      vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit" })
    end,
  },
}
