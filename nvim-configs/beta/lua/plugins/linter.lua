return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    require('lint').linters_by_ft = {
      php = { 'phpstan' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      vue = { 'eslint_d' },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
}
