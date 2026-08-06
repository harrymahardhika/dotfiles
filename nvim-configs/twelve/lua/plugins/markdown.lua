local use = require("plugin-util").use

return use("render-markdown.nvim", "MeanderingProgrammer/render-markdown.nvim", {
  pack = "opt",
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      html = { enabled = false },
      latex = { enabled = false },
      yaml = { enabled = false },
      heading = {
        backgrounds = {},
        width = "full",
      },
      code = {
        style = "normal",
        right_pad = 0,
      },
      bullet = {
        icons = { "•", "◦", "▪" },
      },
      checkbox = {
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
      pipe_table = {
        preset = "none",
      },
    })
  end,
})
