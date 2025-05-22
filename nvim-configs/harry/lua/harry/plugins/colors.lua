return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        no_italic = true,
        integrations = {
          cmp = true,
          copilot_vim = true,
          gitsigns = true,
          grug_far = true,
          mini = {
            enabled = true,
            indentscope_color = "surface0",
          },
          noice = true,
          notify = true,
          nvimtree = true,
          neotree = true,
          treesitter = true,
        }
      })

      vim.cmd("colorscheme catppuccin")
      vim.keymap.set("n", "<leader>tt", function()
        local cat = require("catppuccin")
        cat.options.transparent_background = not cat.options.transparent_background
        cat.options.flavour = "mocha"
        cat.compile()
        vim.cmd.colorscheme(vim.g.colors_name)
      end)
    end
  },
  -- {
  --   "projekt0n/github-nvim-theme",
  --   name = "github-theme",
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require("github-theme").setup({
  --       options = {
  --         transparent = true
  --       }
  --     })
  --
  --     vim.cmd("colorscheme github_dark_dimmed")
  --     -- vim.cmd("colorscheme github_dark_default")
  --     -- vim.cmd("colorscheme github_light")
  --   end,
  -- }
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd("colorscheme tokyonight-moon")
  --     -- vim.cmd("colorscheme tokyonight-night")
  --     -- vim.cmd("colorscheme tokyonight-storm")
  --   end
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd("colorscheme gruvbox")
  --   end
  -- }
}
