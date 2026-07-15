return {
  "cameron-wags/rainbow_csv.nvim",
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
  config = function()
    require("rainbow_csv").setup()
    vim.keymap.set("n", "<leader>ra", ":RainbowAlign<CR>", { desc = "Rainbow align" })
    vim.keymap.set("n", "<leader>rs", ":RainbowShrink<CR>", { desc = "Rainbow shrink" })
  end,
}
