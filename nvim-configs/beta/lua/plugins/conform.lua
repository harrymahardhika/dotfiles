return {
  "stevearc/conform.nvim",
  event = {
    "LspAttach",
    "BufReadPost",
    "BufNewFile",
    "BufWritePre",
  },
  cmd = { "ConformInfo", "ConformFormat" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      php = { "pint" },
      python = { "black", "isort", "autopep8" },
      -- javascript = { "biome" },
      -- typescript = { "biome" },
      -- vue = { "biome" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      vue = { "prettierd" },
    },
    format_on_save = {
      timeout_ms = 10000,
      lsp_fallback = true,
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)
    conform.formatters.prettier = {
      prepend_args = { "--prose-wrap", "always" },
    }
  end,
}
