return {
  "stevearc/conform.nvim",
  event = { "LspAttach", "BufReadPost", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", stop_after_first = true },
      php = { "pint" },
      python = { "black", "isort", "autopep8" },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      -- vue = { "prettierd", "prettier", "eslint_d" },
      vue = { "prettierd", "eslint_d" },
    },

    format_on_save = {
      timeout_ms = 10000,
      lsp_fallback = true,
    },
  },
  config = function(_, opts)
    local conform = require("conform")

    -- Setup "conform.nvim" to work
    conform.setup(opts)

    -- Customise the default "prettier" command to format Markdown files as well
    conform.formatters.prettier = {
      prepend_args = { "--prose-wrap", "always" },
    }
  end,
}
