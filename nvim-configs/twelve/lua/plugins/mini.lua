local use = require("plugin-util").use

return use("mini.nvim", "nvim-mini/mini.nvim", {
  pack = "start",
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
})
