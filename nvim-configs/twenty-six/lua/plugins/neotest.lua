return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "V13Axel/neotest-pest",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-pest"),
      },
    })

    vim.keymap.set("n", "<leader>tn", function()
      neotest.run.run()
    end, { desc = "Test nearest" })

    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Test file" })

    vim.keymap.set("n", "<leader>T", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Test file" })

    vim.keymap.set("n", "<leader>ta", function()
      neotest.run.run({ suite = true })
    end, { desc = "Test suite" })

    vim.keymap.set("n", "<leader>tl", function()
      neotest.run.run_last()
    end, { desc = "Test last" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.summary.toggle()
    end, { desc = "Test summary" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output_panel.toggle()
    end, { desc = "Test output panel" })
  end,
}
