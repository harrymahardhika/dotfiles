return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.load_extension("fzf")

      telescope.setup({
        defaults = {
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        },
        pickers = {
          hidden = true,
          no_ignore = true,
        }
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fa", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fe", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>ff", builtin.git_files, { desc = "Git Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Old Files" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

      vim.keymap.set("n", "<leader>CC", builtin.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>cc", builtin.command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader>rr", builtin.registers, { desc = "Registers" })

      -- Keymaps for LSP
      vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, { desc = "LSP Definitions" })
      vim.keymap.set("n", "<leader>gr", builtin.lsp_implementations, { desc = "LSP Implementations" })

      -- Keymaps for Git
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
    end
  }
}
