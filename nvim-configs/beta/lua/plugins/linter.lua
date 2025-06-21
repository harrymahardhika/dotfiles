return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "biomejs" },
      typescript = { "biomejs" },
      vue = { "biomejs" },
      -- javascript = { "eslint_d" },
      -- typescript = { "eslint_d" },
      -- vue = { "eslint_d" },
      json = { "jsonlint" },
      php = { "phpstan" },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end
}
