return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      -- javascript = { "biome" },
      -- python = { "black", "isort", "autopep8" },
      -- typescript = { "biome" },
      -- vue = { "biome" },
      css = { "prettierd" },
      javascript = { "prettierd" },
      json = { "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      php = { "pint" },
      typescript = { "prettierd" },
      vue = { "prettierd" },
    },
    format_on_save = {
      timeout_ms = 10000,
      lsp_format = "fallback",
    },
    formatters = {
      pint = {
        command = "pint",
        args = { "$FILENAME" },
        stdin = false,
      },
      prettier = {
        prepend_args = { "--prose-wrap", "always" },
      },
    },
  },
}
