local use = require("plugin-util").use

return use("rainbow_csv.nvim", "cameron-wags/rainbow_csv.nvim", {
  pack = "opt",
  ft = {
    "csv",
    "tsv",
    "csv_semicolon",
    "csv_whitespace",
    "csv_pipe",
    "rfc_csv",
    "rfc_semicolon",
  },
  config = function()
    require("rainbow_csv").setup()
    vim.keymap.set("n", "<leader>ra", ":RainbowAlign<CR>", { desc = "Rainbow align" })
    vim.keymap.set("n", "<leader>rs", ":RainbowShrink<CR>", { desc = "Rainbow shrink" })
  end,
})
