return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- javascript = { "biomejs" },
      -- typescript = { "biomejs" },
      -- vue = { "biomejs" },
      javascript = { "eslint_d" },
      json = { "jsonlint" },
      php = { "phpstan" },
      typescript = { "eslint_d" },
      vue = { "eslint_d" },
    }

    -- Run linting on save and when opening a file
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
