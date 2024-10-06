local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    php = { "pint" },
    typescript = { "prettier" },
    vue = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2500,
    lsp_fallback = true,
  },
}

return options
