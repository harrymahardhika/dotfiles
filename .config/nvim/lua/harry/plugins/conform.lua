return {
  "stevearc/conform.nvim",
  event = { "LspAttach", "BufReadPost", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      php = { "pint" },
      typescript = { "prettier" },
      vue = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 5000,
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
