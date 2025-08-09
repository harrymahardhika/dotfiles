return {
  {
    "echasnovski/mini.nvim",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    config = function()
      require("mini.ai").setup()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.splitjoin").setup()
      require("mini.surround").setup()
    end,
  },
}
