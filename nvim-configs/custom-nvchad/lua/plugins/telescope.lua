return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  lazy = false,
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
      },
    })
    pcall(telescope.load_extension, "fzf")

    vim.keymap.set("n", "<leader>f", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find Files" })

    vim.keymap.set("n", "<leader>,", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find Files" })

    vim.keymap.set("n", "<leader>.", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>e", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>R", builtin.oldfiles, { desc = "Recent Files" })

    vim.keymap.set("n", "<leader>C", builtin.commands, { desc = "Commands" })
    vim.keymap.set("n", "<leader>:", builtin.command_history, { desc = "Command History" })
    vim.keymap.set("n", "<leader>r", builtin.registers, { desc = "Registers" })
    vim.keymap.set("n", "<leader>H", builtin.help_tags, { desc = "Help Tags" })

    vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
    vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
    vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git Stash" })
    vim.keymap.set("n", "<leader>gC", builtin.git_bcommits, { desc = "Git Buffer Commits" })

    vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Marks" })
    vim.keymap.set("n", "<leader>sM", builtin.man_pages, { desc = "Man Pages" })
    vim.keymap.set("n", "<leader>st", builtin.tags, { desc = "Tags" })
    vim.keymap.set("n", "<leader>sD", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sd", function()
      builtin.diagnostics({ bufnr = 0 })
    end, { desc = "Buffer Diagnostics" })

    vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "LSP Definitions" })
    -- vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "LSP Type Definitions" })
    vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "LSP Implementations" })
    vim.keymap.set("n", "gR", builtin.lsp_references, { desc = "LSP References" })
    vim.keymap.set("n", "<leader>D", builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
  end,
}
