return {
  "nvchad/ui",
  lazy = false,
  config = function()
    require("nvchad")

    local function transparent_statusline()
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

      for _, group in ipairs(vim.fn.getcompletion("St_", "highlight")) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE" })
      end
    end

    local function set_indentscope_color()
      local ok, colors = pcall(dofile, vim.g.base46_cache .. "colors")
      if not ok or type(colors) ~= "table" then
        return
      end

      local shade = (colors.base_16 and colors.base_16.base02)
        or (colors.base_30 and colors.base_30.one_bg2)
        or colors.grey_fg

      if not shade then
        return
      end

      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = shade })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = shade })
    end

    local function refresh_ui_overrides()
      transparent_statusline()
      set_indentscope_color()
    end

    refresh_ui_overrides()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = refresh_ui_overrides })
  end,
}
