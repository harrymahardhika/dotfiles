return {
  "MeanderingProgrammer/render-markdown.nvim",
  config = function()
    require("render-markdown").setup({
      html = { enabled = false },
      latex = { enabled = false },
      yaml = { enabled = false },
    })
  end,
}
