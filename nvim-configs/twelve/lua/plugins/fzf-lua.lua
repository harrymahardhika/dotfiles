local use = require("plugin-util").use

return use("fzf-lua", "ibhagwan/fzf-lua", {
  pack = "start",
  dependencies = { "nvim-web-devicons" },
  config = function()
    require("nvim-web-devicons")
    local fzf = require("fzf-lua")

    fzf.setup({
      winopts = {
        border = "rounded",
        height = 0.7,
        width = 1.0,
        row = 1.0,
        col = 0.5,
        preview = {
          layout = "flex",
          scrollbar = false,
          winopts = {
            cursorcolumn = false,
            cursorline = true,
            cursorlineopt = "both",
            foldenable = false,
            foldmethod = "manual",
            list = false,
            number = true,
            relativenumber = false,
            scrolloff = 0,
            signcolumn = "no",
            winblend = 0,
          },
        },
      },
    })

    vim.keymap.set("n", "<leader>f", function()
      fzf.files({ hidden = true })
    end, { desc = "Find files" })
    vim.keymap.set("n", "<leader>,", function()
      fzf.files({ hidden = true })
    end, { desc = "Find files" })
    vim.keymap.set("n", "<leader>.", fzf.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>e", fzf.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>/", function()
      fzf.live_grep({ no_ignore = true })
    end, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>R", fzf.oldfiles, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>C", fzf.commands, { desc = "Commands" })
    vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command history" })
    vim.keymap.set("n", "<leader>r", fzf.registers, { desc = "Registers" })
    vim.keymap.set("n", "<leader>H", fzf.help_tags, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
    vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
    vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
    vim.keymap.set("n", "<leader>gS", fzf.git_stash, { desc = "Git stash" })
    vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, { desc = "Git buffer commits" })
    vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Marks" })
    vim.keymap.set("n", "<leader>sM", fzf.manpages, { desc = "Man pages" })
    vim.keymap.set("n", "<leader>st", fzf.tags, { desc = "Tags" })
    vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Buffer diagnostics" })
    vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "LSP definitions" })
    vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP implementations" })
    vim.keymap.set("n", "gR", fzf.lsp_references, { desc = "LSP references" })
    vim.keymap.set("n", "<leader>D", fzf.lsp_document_symbols, { desc = "LSP document symbols" })
  end,
})
