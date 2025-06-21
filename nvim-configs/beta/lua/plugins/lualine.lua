return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = "",
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        theme = "catppuccin",
      },
      sections = {
        lualine_a = { "fancy_branch" },
        lualine_b = { "fancy_diff", "fancy_diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "fancy_macro", "location" },
        lualine_y = {},
        lualine_z = {}
      },
    })
  end
}
