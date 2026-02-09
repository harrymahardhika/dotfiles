return {
  "cameron-wags/rainbow_csv.nvim",
  config = function()
    require("rainbow_csv").setup()
    vim.keymap.set("n", "<leader>ra", ":RainbowAlign<CR>")
    vim.keymap.set("n", "<leader>rs", ":RainbowShrink<CR>")
  end,
  ft = {
    "csv",
    "tsv",
    "csv_semicolon",
    "csv_whitespace",
    "csv_pipe",
    "rfc_csv",
    "rfc_semicolon",
  },
  cmd = {
    "RainbowDelim",
    "RainbowDelimSimple",
    "RainbowDelimQuoted",
    "RainbowMultiDelim",
  },
}
