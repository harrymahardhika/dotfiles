local use = require("plugin-util").use

return use("conform.nvim", "stevearc/conform.nvim", {
  pack = "start",
  config = function()
    local function executable(cmd)
      return vim.fn.executable(cmd) == 1
    end

    local function first_available(commands)
      for _, cmd in ipairs(commands) do
        if executable(cmd) then
          return cmd
        end
      end
    end

    local prettierd = first_available({ "prettierd", "prettier" })
    local lua_formatter = first_available({ "stylua" })
    local php_formatter = first_available({ "pint" })

    local formatters_by_ft = {}
    if prettierd then
      formatters_by_ft.css = { prettierd }
      formatters_by_ft.javascript = { prettierd }
      formatters_by_ft.json = { prettierd }
      formatters_by_ft.json5 = { prettierd }
      formatters_by_ft.jsonc = { prettierd }
      formatters_by_ft.markdown = { prettierd }
      formatters_by_ft.typescript = { prettierd }
      formatters_by_ft.vue = { prettierd }
    end
    if lua_formatter then
      formatters_by_ft.lua = { lua_formatter }
    end
    if php_formatter then
      formatters_by_ft.php = { php_formatter }
    end

    require("conform").setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = {
        timeout_ms = 10000,
        lsp_fallback = true,
      },
    })
  end,
})
