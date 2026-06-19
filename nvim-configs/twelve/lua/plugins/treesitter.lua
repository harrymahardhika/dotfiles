local use = require("plugin-util").use

return use("nvim-treesitter", "nvim-treesitter/nvim-treesitter", {
  pack = "start",
  config = function()
    vim.treesitter.language.register('bash', 'zsh')
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
        "bash",
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
