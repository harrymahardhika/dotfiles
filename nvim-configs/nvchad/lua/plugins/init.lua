return {
  -- Conform (formatting) - already exists in NvChad but we'll customize it
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        css = { "prettierd" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        php = { "pint" },
        typescript = { "prettierd" },
        vue = { "prettierd" },
      },
      format_on_save = {
        timeout_ms = 10000,
        lsp_format = "fallback",
      },
      formatters = {
        pint = {
          command = "pint",
          args = { "$FILENAME" },
          stdin = false,
        },
        prettier = {
          prepend_args = { "--prose-wrap", "always" },
        },
      },
    },
  },

  -- LSP Config - NvChad has this but we customize it
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Treesitter - customize NvChad's default
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "csv",
        "html",
        "css",
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
        "vim",
        "vimdoc",
        "vue",
      },
    },
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false,
  },

  -- Oil file explorer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      view_options = { show_hidden = true },
      win_options = { signcolumn = "yes:1" },
    },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    config = true,
  },

  -- FZF Lua
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        winopts = {
          border = "rounded",
          height = 0.7,
          width = 1.0,
          row = 1.0,
          col = 0.5,
          preview = {
            layout = "flex",
            scrollbar = false,
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>f", function()
        require("fzf-lua").files({ hidden = true })
      end, { desc = "Find Files" })

      vim.keymap.set("n", "<leader>,", function()
        require("fzf-lua").files({ hidden = true })
      end, { desc = "Find Files" })

      vim.keymap.set("n", "<leader>.", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>e", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>R", fzf.oldfiles, { desc = "Recent Files" })

      vim.keymap.set("n", "<leader>C", fzf.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader>r", fzf.registers, { desc = "Registers" })
      vim.keymap.set("n", "<leader>H", fzf.help_tags, { desc = "Help Tags" })

      vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git Branches" })
      vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
      vim.keymap.set("n", "<leader>gS", fzf.git_stash, { desc = "Git Stash" })
      vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, { desc = "Git Buffer Commits" })

      vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Marks" })
      vim.keymap.set("n", "<leader>sM", fzf.manpages, { desc = "Man Pages" })
      vim.keymap.set("n", "<leader>st", fzf.tags, { desc = "Tags" })
      vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Buffer Diagnostics" })

      vim.keymap.set("n", "gd", fzf.lsp_typedefs, { desc = "LSP Type Definitions" })
      vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP Implementations" })
      vim.keymap.set("n", "gR", fzf.lsp_references, { desc = "LSP References" })
      vim.keymap.set("n", "<leader>D", fzf.lsp_document_symbols, { desc = "LSP Document Symbols" })
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        current_line_blame = true,
        on_attach = function(bufnr)
          local function set_keymap(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          set_keymap("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          set_keymap("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          set_keymap("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "Diff this" })
          set_keymap("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
          set_keymap("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
          set_keymap("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Blame line" })
          set_keymap("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
          set_keymap("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
          set_keymap("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
          set_keymap("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
          set_keymap("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
          set_keymap("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          set_keymap("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })

          -- Text object
          set_keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    config = function()
      vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit" })
    end,
  },

  -- Mini.nvim modules
  {
    "nvim-mini/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.splitjoin").setup()
      require("mini.surround").setup()
    end,
  },

  -- Which-key (helps with keybinding discovery)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Grug-far (search and replace)
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({})
      vim.keymap.set("n", "<leader>S", "<cmd>GrugFar<CR>", { desc = "Search and Replace" })
    end,
  },

  -- Text case conversion
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
    end,
  },

  -- Wakatime
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- CSV support
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe", "rfc_csv", "rfc_semicolon" },
    cmd = { "RainbowDelim", "RainbowDelimSimple", "RainbowDelimQuoted", "RainbowMultiDelim" },
  },

  -- Emmet for HTML/CSS
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "vue", "javascript", "typescript" },
  },

  -- Markdown preview
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },

  -- Vim Test
  {
    "vim-test/vim-test",
    config = function()
      vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", { desc = "Test Nearest" })
      vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Test File" })
      vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = "Test Suite" })
      vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Test Last" })
      vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Test Visit" })
    end,
  },

  -- Linter (nvim-lint)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        vue = { "eslint_d" },
        php = { "phpstan" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  -- LSP helper plugins
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}
