return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { 'biomejs' },
      json = { 'jsonlint' },
      php = { 'phpstan' },
      typescript = { 'biomejs' },
      vue = { 'biomejs' },
    }


    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end
}
