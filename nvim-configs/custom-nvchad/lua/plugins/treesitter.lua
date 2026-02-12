return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "TSInstall",
      "TSInstallInfo",
      "TSInstallFromGrammar",
      "TSUninstall",
      "TSLog",
      "TSUpdate",
    },
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
    opts = {
      auto_install = false,
      ensure_installed = {
        "bash",
        "csv",
        "css",
        "html",
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
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
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
    },
    config = function(_, opts)
      local ok_configs, ts_configs = pcall(require, "nvim-treesitter.configs")
      if ok_configs then
        ts_configs.setup(opts)
      else
        -- Newer nvim-treesitter API: setup() no longer configures highlight modules.
        require("nvim-treesitter").setup({})

        local highlight_disable = opts.highlight and opts.highlight.disable
        local group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true })
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
          group = group,
          callback = function(args)
            local buf = args.buf
            local ft = vim.bo[buf].filetype
            if not ft or ft == "" then
              return
            end

            local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
            lang = (ok_lang and lang) or ft
            if not lang or lang == "" then
              return
            end

            if type(highlight_disable) == "function" and highlight_disable(lang, buf) then
              return
            end

            local ok_start = pcall(vim.treesitter.start, buf, lang)
            if ok_start and opts.highlight and opts.highlight.additional_vim_regex_highlighting == false then
              pcall(vim.api.nvim_set_option_value, "syntax", "off", { buf = buf })
            end
          end,
        })
      end

      if vim.fn.exists(":TSInstallInfo") == 0 then
        vim.api.nvim_create_user_command("TSInstallInfo", function()
          local ts = require("nvim-treesitter")
          local installed = ts.get_installed()
          table.sort(installed)
          vim.notify(
            ("Installed parsers (%d): %s"):format(#installed, table.concat(installed, ", ")),
            vim.log.levels.INFO,
            { title = "nvim-treesitter" }
          )
        end, { desc = "Show installed treesitter parsers" })
      end

      -- Set up treesitter-based folding
      vim.opt.foldmethod = "expr"
      if vim.treesitter and vim.treesitter.foldexpr then
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      else
        vim.opt.foldexpr = "0"
      end
      vim.opt.foldenable = true -- Ensure folding is enabled
    end,
  },
}
