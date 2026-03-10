return {
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "danymat/neogen",
    config = true, -- Load default configuration
    keys = {
      {
        "<leader>df",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Generate Function Docblock",
      },
      {
        "<leader>dc",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Generate Class Docblock",
      },
    },
  },
}
