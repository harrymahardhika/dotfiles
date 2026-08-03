return {
  {
    "rebelot/kanagawa.nvim",
    name     = "kanagawa",
    priority = 1000,
    config   = function()
      require("kanagawa").setup({
        theme = "wave",
        transparent = true,
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { italic = false },
        functionStyle = { italic = false },
        overrides = function(colors)
          return {
            StatusLine = { bg = "none" },
            StatusLineNC = { bg = "none" },
            WinBar = { bg = "none" },
            WinBarNC = { bg = "none" },
            SignColumn = { bg = "none" },
            LineNr = { bg = "none" },
            CursorLineNr = { bg = "none" },
            NormalNC = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
          }
        end,
      })

      vim.cmd("colorscheme kanagawa")
      vim.keymap.set("n", "<leader>tt", function()
        require("kanagawa").load("wave")
        vim.o.background = "dark"
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
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
