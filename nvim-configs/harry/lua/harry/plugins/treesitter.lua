return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {
          "bash",
          "javascript",
          "lua",
          "php",
          "markdown",
          "regex",
          "typescript",
          "vue"
        },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = {
          enable = true,
        }
      })
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup {
          pre_hook = function()
            return vim.bo.commentstring
          end,
        }
      end,
    },
  },
  {
    "danymat/neogen",
    config = true, -- Load default configuration
    keys = {
      { "<leader>df", function() require("neogen").generate({ type = "func" }) end,  desc = "Generate Function Docblock" },
      { "<leader>dc", function() require("neogen").generate({ type = "class" }) end, desc = "Generate Class Docblock" },
    }
  }
}
