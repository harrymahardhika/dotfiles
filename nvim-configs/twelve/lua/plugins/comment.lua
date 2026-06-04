local use = require("plugin-util").use

return {
  use("Comment.nvim", "numToStr/Comment.nvim", {
    pack = "start",
    dependencies = { "nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup()
    end,
  }),
  use("nvim-ts-context-commentstring", "JoosepAlviste/nvim-ts-context-commentstring", { pack = "start" }),
}
