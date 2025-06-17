return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = "",
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        theme = "catppuccin",
      },
      sections = {
        lualine_a = { "branch" },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = { "progress" },
        lualine_z = { "location", }
      },
    })
  end
}
