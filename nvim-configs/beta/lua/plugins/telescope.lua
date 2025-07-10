return {
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")

      telescope.load_extension("fzf")

      telescope.setup({
        defaults = {
          layout_config = { prompt_position = "top" },
          path_display = { truncate = 3 },
          sorting_strategy = "ascending",
        },
        pickers = {
          hidden = true,
          no_ignore = true,
        }
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n",
        "<leader><space>",
        function() builtin.find_files({ hidden = true, no_ignore = false }) end,
        { desc = "Find Files" }
      )
      vim.keymap.set(
        "n",
        "<leader>ff",
        function() builtin.find_files({ hidden = true, no_ignore = false }) end,
        { desc = "Find Files" }
      )
      vim.keymap.set("n", "<leader>,", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>.", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find Git Files" })
      vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Current Buffer" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })

      vim.keymap.set("n", "<leader>C", builtin.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>:", builtin.command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader>r", builtin.registers, { desc = "Registers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })

      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
      vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git Stash" })
      vim.keymap.set("n", "<leader>gC", builtin.git_bcommits, { desc = "Git Buffer Commits" })

      vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Marks" })
      vim.keymap.set("n", "<leader>sM", builtin.man_pages, { desc = "Man Pages" })
      vim.keymap.set("n", "<leader>st", builtin.tags, { desc = "Tags" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })

      vim.keymap.set("n", "gd", builtin.lsp_type_definitions, { desc = "LSP Type Definitions" })
      vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "LSP Implementations" })
      vim.keymap.set("n", "gR", builtin.lsp_references, { desc = "LSP References" })
      vim.keymap.set("n", "<leader>fd", builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
    end
  }
}
