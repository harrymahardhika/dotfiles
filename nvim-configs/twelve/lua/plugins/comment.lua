local use = require("plugin-util").use

return {
  use("Comment.nvim", "numToStr/Comment.nvim", {
    pack = "start",
    dependencies = { "nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  }),
  use("nvim-ts-context-commentstring", "JoosepAlviste/nvim-ts-context-commentstring", { pack = "start" }),
}
