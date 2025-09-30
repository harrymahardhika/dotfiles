return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional for icons
    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        winopts = {
          border = "rounded",
          height = 0.7, -- 50% of total height
          width = 1.0, -- full width
          row = 1.0, -- align to bottom
          col = 0.5, -- center horizontally
          preview = {
            layout = "flex",
            scrollbar = false,
          },
        },
      })

      -- Keymaps (mirroring your Telescope setup)
      vim.keymap.set("n", "<leader><space>", function()
        require("fzf-lua").files({ hidden = true }) -- no cwd field
      end, { desc = "Find Files" })

      vim.keymap.set("n", "<leader>f", function()
        require("fzf-lua").files({ hidden = true })
      end, { desc = "Find Files" })

      vim.keymap.set("n", "<leader>,", function()
        require("fzf-lua").files({ hidden = true })
      end, { desc = "Find Files" })

      vim.keymap.set("n", "<leader>.", fzf.buffers, { desc = "Buffers" })
      -- vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Live Grep" })
      -- vim.keymap.set("n", "<leader>fg", fzf.git_files, { desc = "Git Files" })
      -- vim.keymap.set("n", "<leader>f/", fzf.blines, { desc = "Fuzzy Find in Buffer" })
      -- vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
      vim.keymap.set("n", "<leader>R", fzf.oldfiles, { desc = "Recent Files" })

      vim.keymap.set("n", "<leader>C", fzf.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader>r", fzf.registers, { desc = "Registers" })
      -- vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>H", fzf.help_tags, { desc = "Help Tags" })

      vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git Branches" })
      vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
      vim.keymap.set("n", "<leader>gS", fzf.git_stash, { desc = "Git Stash" })
      vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, { desc = "Git Buffer Commits" })

      vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Marks" })
      vim.keymap.set("n", "<leader>sM", fzf.manpages, { desc = "Man Pages" })
      vim.keymap.set("n", "<leader>st", fzf.tags, { desc = "Tags" })
      vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Buffer Diagnostics" })

      vim.keymap.set("n", "gd", fzf.lsp_typedefs, { desc = "LSP Type Definitions" })
      vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP Implementations" })
      vim.keymap.set("n", "gR", fzf.lsp_references, { desc = "LSP References" })
      vim.keymap.set("n", "<leader>D", fzf.lsp_document_symbols, { desc = "LSP Document Symbols" })
    end,
  },
}
