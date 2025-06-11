return {
  "johmsalas/text-case.nvim",
  config = function() require("textcase").setup({}) end,
  keys = { "ga" },
  cmd = {
    "Subs",
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
}
