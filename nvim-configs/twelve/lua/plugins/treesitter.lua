local use = require("plugin-util").use

return use("nvim-treesitter", "nvim-treesitter/nvim-treesitter", {
  pack = "start",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "javascript",
        "typescript",
        "vue",
        "css",
        "html",
        "yaml",
        "json",
      },
      auto_install = false,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
})
