local use = require("plugin-util").use

return {
  use("nvim-nio", "nvim-neotest/nvim-nio", { pack = "opt" }),
  use("FixCursorHold.nvim", "antoinemadec/FixCursorHold.nvim", { pack = "opt" }),
  use("neotest-pest", "V13Axel/neotest-pest", { pack = "opt" }),
  use("neotest", "nvim-neotest/neotest", {
    pack = "opt",
    dependencies = { "nvim-nio", "plenary.nvim", "FixCursorHold.nvim", "neotest-pest" },
    keys = {
      {
        lhs = "<leader>tn",
        desc = "Test nearest",
        rhs = function()
          require("neotest").run.run()
        end,
      },
      {
        lhs = "<leader>tf",
        desc = "Test file",
        rhs = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        lhs = "<leader>T",
        desc = "Test file",
        rhs = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        lhs = "<leader>ta",
        desc = "Test suite",
        rhs = function()
          require("neotest").run.run({ suite = true })
        end,
      },
      {
        lhs = "<leader>tl",
        desc = "Test last",
        rhs = function()
          require("neotest").run.run_last()
        end,
      },
      {
        lhs = "<leader>ts",
        desc = "Test summary",
        rhs = function()
          require("neotest").summary.toggle()
        end,
      },
      {
        lhs = "<leader>to",
        desc = "Test output panel",
        rhs = function()
          require("neotest").output_panel.toggle()
        end,
      },
    },
    config = function()
      local neotest = require("neotest")

      ---@diagnostic disable-next-line: missing-fields
      neotest.setup({
        adapters = {
          require("neotest-pest"),
        },
      })
    end,
  }),
}
