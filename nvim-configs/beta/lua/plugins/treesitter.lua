return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = false,
        ensure_installed = { "bash", "javascript", "lua", "markdown", "php", "python", "regex", "typescript", "vue" },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        ignore_install = {},
        indent = { enable = true, },
        modules = {},
        sync_install = false,
      })
    end
  },
}
