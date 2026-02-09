return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup({
            opts = {
              enable_close = true,
              enable_rename = true,
              enable_close_on_slash = true,
            },
          })
        end,
      },
    },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = false,
        ensure_installed = {
          "bash",
          "csv",
          "javascript",
          "json",
          "jsonc",
          "lua",
          "markdown",
          "php",
          "python",
          "regex",
          "toml",
          "typescript",
          "vue",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          -- Performance: Disable for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        ignore_install = {},
        indent = {
          enable = true,
          -- Performance: Disable indent for problematic languages
          disable = { "python", "yaml" },
        },
        modules = {},
        sync_install = false,
      })

      -- Set up treesitter-based folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = true -- Ensure folding is enabled
    end,
  },
}
