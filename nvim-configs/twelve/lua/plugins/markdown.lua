local use = require("plugin-util").use

return use("render-markdown.nvim", "MeanderingProgrammer/render-markdown.nvim", {
  pack = "opt",
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      html = { enabled = false },
      latex = { enabled = false },
      yaml = { enabled = false },
    })
  end,
})
