return {
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension("fzf")
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fe", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fp", builtin.git_files, { desc = "Git Files" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Old Files" })
      vim.keymap.set("n", "<leader>rr", ":Telescope registers<CR>", { desc = "Registers" })
    end
  }
}
