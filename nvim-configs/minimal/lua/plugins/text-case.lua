return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("textcase").setup({})
    require("telescope").load_extension("textcase")
  end,
  keys = {
    { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Change case" },
  },
  cmd = {
    "Subs",
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
}
