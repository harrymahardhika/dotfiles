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
          "markdown",
          "php",
          "python",
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
}
