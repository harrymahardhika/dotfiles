local use = require("plugin-util").use

return use("which-key.nvim", "folke/which-key.nvim", {
  pack = "opt",
  event = "VimEnter",
  config = function()
    require("which-key").setup({
      preset = "helix",
    })
  end,
})
