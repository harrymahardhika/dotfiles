local options = {
  formatters_by_ft = {
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
    lsp_fallback = true,
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
}

return options

