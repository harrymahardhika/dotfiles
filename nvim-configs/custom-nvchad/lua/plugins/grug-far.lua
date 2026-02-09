return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open()
      end,
      desc = "Search and Replace (Grug Far)",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Search and Replace word under cursor",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
      end,
      mode = "v",
      desc = "Search and Replace visual selection",
    },
  },
  config = function()
    require("grug-far").setup({
      -- options, see Configuration section below
      -- there are no required options atm
    })
  end,
}
