return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = "",
        icons_enabled = true,
        section_separators = "",
        theme = "catppuccin",
      },
      sections = {
        lualine_a = {},
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = { "progress" },
        lualine_z = { "location" }
      },
    })
  end
}
