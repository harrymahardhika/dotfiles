return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        transparent_background = true,
        no_italic = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          mini = {
            enabled = true,
            indentscope_color = "surface0",
          },
          noice = true,
          notify = true,
          nvimtree = true,
          neotree = true,
          treesitter = true,
        },
      }

      -- vim.cmd "colorscheme catppuccin"
      vim.keymap.set("n", "<leader>tt", function()
        local cat = require "catppuccin"
        cat.options.transparent_background = not cat.options.transparent_background
        cat.options.flavour = "mocha"
        cat.compile()
        vim.cmd.colorscheme(vim.g.colors_name)
      end)
    end,
  },
}
