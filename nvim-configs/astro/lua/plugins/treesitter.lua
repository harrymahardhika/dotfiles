-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "javascript",
      "lua",
      "typescript",
      "vim",
      "vue",
    },
  },
}
