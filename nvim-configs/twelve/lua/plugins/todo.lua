local use = require("plugin-util").use

return use("todo-comments.nvim", "folke/todo-comments.nvim", {
  pack = "opt",
  event = "VimEnter",
  dependencies = { "plenary.nvim" },
  config = function()
    require("todo-comments").setup({})
  end,
})
