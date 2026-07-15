return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin", "GrugFarResume" },
  config = function()
    require("grug-far").setup({})
  end,
}
