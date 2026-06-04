local use = require("plugin-util").use

return use("grug-far.nvim", "MagicDuck/grug-far.nvim", {
  pack = "opt",
  cmd = { "GrugFar", "GrugFarWithin", "GrugFarResume" },
  config = function()
    require("grug-far").setup({})
  end,
})
