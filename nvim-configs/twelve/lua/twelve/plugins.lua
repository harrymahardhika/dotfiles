local function use(name, repo, opts)
  opts = opts or {}
  opts.name = name
  opts.repo = repo
  return opts
end

return {
  use("catppuccin", "catppuccin/nvim", {
    pack = "start",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        auto_integrations = true,
        flavour = "mocha",
        transparent_background = true,
        float = {
          transparent = true,
          solid = false,
        },
        no_italic = true,
        integrations = {
          cmp = true,
          copilot_vim = true,
          gitsigns = true,
          grug_far = true,
          mini = {
            enabled = true,
            indentscope_color = "surface0",
          },
          which_key = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  }),
  use("plenary.nvim", "nvim-lua/plenary.nvim", { pack = "start" }),
  use("nvim-web-devicons", "nvim-tree/nvim-web-devicons", { pack = "start" }),
  use("Comment.nvim", "numToStr/Comment.nvim", {
    pack = "start",
    dependencies = { "nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup()
    end,
  }),
  use("nvim-ts-context-commentstring", "JoosepAlviste/nvim-ts-context-commentstring", { pack = "start" }),
  use("todo-comments.nvim", "folke/todo-comments.nvim", {
    pack = "opt",
    event = "VimEnter",
    dependencies = { "plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  }),
  use("conform.nvim", "stevearc/conform.nvim", {
    pack = "start",
    config = function()
      local function executable(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local function first_available(commands)
        for _, cmd in ipairs(commands) do
          if executable(cmd) then
            return cmd
          end
        end
      end

      local prettierd = first_available({ "prettierd", "prettier" })
      local lua_formatter = first_available({ "stylua" })
      local php_formatter = first_available({ "pint" })

      local formatters_by_ft = {}
      if prettierd then
        formatters_by_ft.css = { prettierd }
        formatters_by_ft.javascript = { prettierd }
        formatters_by_ft.json = { prettierd }
        formatters_by_ft.json5 = { prettierd }
        formatters_by_ft.jsonc = { prettierd }
        formatters_by_ft.markdown = { prettierd }
        formatters_by_ft.typescript = { prettierd }
        formatters_by_ft.vue = { prettierd }
      end
      if lua_formatter then
        formatters_by_ft.lua = { lua_formatter }
      end
      if php_formatter then
        formatters_by_ft.php = { php_formatter }
      end

      require("conform").setup({
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          timeout_ms = 10000,
          lsp_fallback = true,
        },
        formatters = {
          pint = {
            command = "pint",
            args = { "$FILENAME" },
            stdin = false,
          },
        },
      })
    end,
  }),
  use("rainbow_csv.nvim", "cameron-wags/rainbow_csv.nvim", {
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
  }),
  use("emmet-vim", "mattn/emmet-vim", {
    pack = "opt",
    ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-y>"
      vim.g.user_emmet_mode = "a"
      vim.g.user_emmet_settings = {
        vue = { extends = "html" },
        svelte = { extends = "html" },
        javascriptreact = { extends = "jsx" },
        typescriptreact = { extends = "jsx" },
      }
    end,
  }),
  use("fzf-lua", "ibhagwan/fzf-lua", {
    pack = "start",
    dependencies = { "nvim-web-devicons" },
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
            winopts = {
              cursorcolumn = false,
              cursorline = true,
              cursorlineopt = "both",
              foldenable = false,
              foldmethod = "manual",
              list = false,
              number = true,
              relativenumber = false,
              scrolloff = 0,
              signcolumn = "no",
              winblend = 0,
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        fzf.files({ hidden = true })
      end, { desc = "Find files" })
      vim.keymap.set("n", "<leader>,", function()
        fzf.files({ hidden = true })
      end, { desc = "Find files" })
      vim.keymap.set("n", "<leader>.", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>e", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>/", function()
        fzf.live_grep({ no_ignore = true })
      end, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>R", fzf.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>C", fzf.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command history" })
      vim.keymap.set("n", "<leader>r", fzf.registers, { desc = "Registers" })
      vim.keymap.set("n", "<leader>H", fzf.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
      vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
      vim.keymap.set("n", "<leader>gS", fzf.git_stash, { desc = "Git stash" })
      vim.keymap.set("n", "<leader>gC", fzf.git_bcommits, { desc = "Git buffer commits" })
      vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Marks" })
      vim.keymap.set("n", "<leader>sM", fzf.manpages, { desc = "Man pages" })
      vim.keymap.set("n", "<leader>st", fzf.tags, { desc = "Tags" })
      vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Buffer diagnostics" })
      vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "LSP definitions" })
      vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP implementations" })
      vim.keymap.set("n", "gR", fzf.lsp_references, { desc = "LSP references" })
      vim.keymap.set("n", "<leader>D", fzf.lsp_document_symbols, { desc = "LSP document symbols" })
    end,
  }),
  use("gitsigns.nvim", "lewis6991/gitsigns.nvim", {
    pack = "start",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        current_line_blame = true,
        on_attach = function(bufnr)
          local function set_keymap(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

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
          set_keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  }),
  use("diffview.nvim", "sindrets/diffview.nvim", { pack = "opt" }),
  use("neogit", "NeogitOrg/neogit", {
    pack = "opt",
    cmd = { "Neogit" },
    dependencies = { "plenary.nvim", "diffview.nvim", "fzf-lua" },
    keys = {
      {
        lhs = "<leader>gn",
        desc = "Neogit",
        rhs = function()
          vim.cmd("Neogit")
        end,
      },
    },
    config = function()
      require("neogit").setup({})
    end,
  }),
  use("grug-far.nvim", "MagicDuck/grug-far.nvim", {
    pack = "opt",
    cmd = { "GrugFar", "GrugFarWithin", "GrugFarResume" },
    config = function()
      require("grug-far").setup({})
    end,
  }),
  use("nvim-lint", "mfussenegger/nvim-lint", {
    pack = "start",
    config = function()
      local lint = require("lint")
      local uv = vim.uv
      local warned_missing = {}

      local function executable(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local function notify_missing(tool)
        if warned_missing[tool] then
          return
        end
        warned_missing[tool] = true
        vim.schedule(function()
          vim.notify(("Skipping linter, executable not found: %s"):format(tool), vim.log.levels.WARN, {
            title = "twelve.lint",
          })
        end)
      end

      local function first_available(commands)
        for _, cmd in ipairs(commands) do
          if executable(cmd) then
            return cmd
          end
        end
      end

      local function php_root(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(path)
        if not dir or dir == "" then
          return uv.cwd()
        end

        local marker = vim.fs.find({ "phpstan.neon", "phpstan.neon.dist", "composer.json", ".git" }, {
          path = dir,
          upward = true,
        })[1]
        return marker and vim.fs.dirname(marker) or dir
      end

      local function normalize_path(path, base)
        if not path or path == "" then
          return nil
        end
        if base and not path:match("^/") then
          path = vim.fs.joinpath(base, path)
        end
        local real = uv.fs_realpath(path)
        return vim.fs.normalize(real or path)
      end

      local phpstan = require("lint.linters.phpstan")
      phpstan.args = {
        "analyze",
        "--error-format=json",
        "--no-progress",
      }
      phpstan.parser = function(output, bufnr)
        if not output or vim.trim(output) == "" then
          return {}
        end

        local ok, decoded = pcall(vim.json.decode, output)
        if not ok or type(decoded) ~= "table" then
          return {}
        end

        local files = decoded.files or {}
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local root = php_root(bufnr)
        local target = normalize_path(bufname)
        local file = files[bufname]

        if not file then
          for key, val in pairs(files) do
            if normalize_path(key, root) == target then
              file = val
              break
            end
          end
        end

        if not file then
          return {}
        end

        local diagnostics = {}
        for _, message in ipairs(file.messages or {}) do
          diagnostics[#diagnostics + 1] = {
            lnum = type(message.line) == "number" and (message.line - 1) or 0,
            col = 0,
            message = message.message,
            source = "phpstan",
            code = message.identifier,
          }
        end
        return diagnostics
      end

      local js_linter = first_available({ "eslint_d", "eslint" })
      local json_linter = first_available({ "jsonlint" })
      local php_linter = executable("phpstan") and "phpstan" or nil

      lint.linters_by_ft = {}
      if js_linter then
        lint.linters_by_ft.javascript = { js_linter }
        lint.linters_by_ft.typescript = { js_linter }
        lint.linters_by_ft.vue = { js_linter }
      end
      if json_linter then
        lint.linters_by_ft.json = { json_linter }
      end
      if php_linter then
        lint.linters_by_ft.php = { php_linter }
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("TwelveLint", { clear = true }),
        callback = function()
          if vim.bo.filetype == "php" then
            if php_linter then
              lint.try_lint("phpstan", { cwd = php_root(0) })
            else
              notify_missing("phpstan")
            end
          else
            local ft = vim.bo.filetype
            local configured = lint.linters_by_ft[ft]
            if configured and #configured > 0 then
              lint.try_lint(configured)
            elseif ft == "javascript" or ft == "typescript" or ft == "vue" then
              notify_missing("eslint_d")
            elseif ft == "json" then
              notify_missing("jsonlint")
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("TwelveLintPhp", { clear = true }),
        pattern = "*.php",
        callback = function()
          if php_linter then
            lint.try_lint("phpstan", { cwd = php_root(0) })
          else
            notify_missing("phpstan")
          end
        end,
      })
    end,
  }),
  use("nvim-cmp", "hrsh7th/nvim-cmp", {
    pack = "opt",
    event = "InsertEnter",
    dependencies = { "cmp-nvim-lsp", "cmp-buffer", "LuaSnip", "cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        performance = {
          debounce = 150,
          throttle = 60,
          fetching_timeout = 500,
          max_view_entries = 50,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          {
            name = "buffer",
            priority = 500,
            keyword_length = 3,
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
        },
      })
    end,
  }),
  use("cmp-nvim-lsp", "hrsh7th/cmp-nvim-lsp", { pack = "opt" }),
  use("cmp-buffer", "hrsh7th/cmp-buffer", { pack = "opt" }),
  use("LuaSnip", "L3MON4D3/LuaSnip", { pack = "opt" }),
  use("cmp_luasnip", "saadparwaiz1/cmp_luasnip", { pack = "opt" }),
  use("lazydev.nvim", "folke/lazydev.nvim", { pack = "opt" }),
  use("fidget.nvim", "j-hui/fidget.nvim", {
    pack = "opt",
    event = "LspAttach",
    config = function()
      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
          },
        },
      })
    end,
  }),
  use("nvim-lspconfig", "neovim/nvim-lspconfig", {
    pack = "start",
    dependencies = { "cmp-nvim-lsp", "lazydev.nvim" },
    config = function()
      vim.g.lsp_file_size_limit = 5000000
      vim.lsp.log.set_level("ERROR")

      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.semanticTokens = vim.NIL
      local missing_servers = {}

      local function executable_exists(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local function record_missing(server, cmd)
        missing_servers[#missing_servers + 1] = ("%s (%s)"):format(server, cmd)
      end

      local function enable_server(server, opts)
        opts = opts or {}
        local cmd = opts.cmd

        local config = vim.deepcopy(opts)
        config.cmd = nil

        vim.lsp.config(server, config)

        if cmd and not executable_exists(cmd) then
          record_missing(server, cmd)
          return
        end

        vim.lsp.enable(server)
      end

      local function intelephense_capabilities(client)
        local server_caps = client.server_capabilities or {}
        server_caps.definitionProvider = nil
        server_caps.typeDefinitionProvider = nil
        server_caps.declarationProvider = nil
        server_caps.implementationProvider = nil
      end

      local function phpactor_capabilities(client)
        local server_caps = client.server_capabilities or {}
        local allowed = {
          codeActionProvider = true,
          declarationProvider = true,
          definitionProvider = true,
          executeCommandProvider = true,
          hoverProvider = true,
          implementationProvider = true,
          renameProvider = true,
          typeDefinitionProvider = true,
        }

        for _, capability in ipairs(vim.tbl_keys(server_caps)) do
          if capability:find("Provider", 1, true) and not allowed[capability] then
            server_caps[capability] = nil
          end
        end
      end

      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      })

      enable_server("lua_ls", {
        cmd = "lua-language-server",
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      enable_server("intelephense", {
        cmd = "intelephense",
        on_attach = intelephense_capabilities,
        capabilities = capabilities,
      })

      enable_server("phpactor", {
        cmd = "phpactor",
        on_attach = phpactor_capabilities,
        capabilities = capabilities,
      })

      enable_server("gopls", {
        cmd = "gopls",
        capabilities = capabilities,
      })

      local vue_language_server_path = "/usr/lib/node_modules/@vue/language-server"
      local vue_typescript_sdk = "/usr/lib/node_modules/@vtsls/language-server/node_modules/typescript/lib"
      local has_vue_plugin = vim.uv.fs_stat(vue_language_server_path) ~= nil
      local has_vue_sdk = vim.uv.fs_stat(vue_typescript_sdk) ~= nil
      local vtsls_settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {},
          },
        },
        typescript = {
          preferences = {
            importModuleSpecifier = "non-relative",
            importModuleSpecifierEnding = "minimal",
          },
          tsserver = {
            maxTsServerMemory = 8192,
          },
        },
        javascript = {
          preferences = {
            importModuleSpecifier = "non-relative",
            importModuleSpecifierEnding = "minimal",
          },
        },
      }

      if has_vue_plugin then
        table.insert(vtsls_settings.vtsls.tsserver.globalPlugins, {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        })
      end

      enable_server("vtsls", {
        cmd = "vtsls",
        capabilities = capabilities,
        settings = vtsls_settings,
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })

      enable_server("vue_ls", {
        cmd = "vue-language-server",
        capabilities = capabilities,
        filetypes = { "vue" },
        init_options = has_vue_sdk and {
          typescript = {
            tsdk = vue_typescript_sdk,
          },
        } or nil,
      })

      enable_server("tailwindcss", {
        cmd = "tailwindcss-language-server",
        capabilities = capabilities,
        filetypes = { "javascript", "typescript", "vue", "svelte" },
      })

      if #missing_servers > 0 then
        vim.schedule(function()
          vim.notify(
            "Skipped LSP servers with missing executables: " .. table.concat(missing_servers, ", "),
            vim.log.levels.WARN,
            { title = "twelve.lsp" }
          )
        end)
      end

      if not has_vue_plugin then
        vim.schedule(function()
          vim.notify(
            "Vue TypeScript plugin path not found at " .. vue_language_server_path .. ". Vue hybrid mode is disabled until it is installed.",
            vim.log.levels.WARN,
            { title = "twelve.lsp" }
          )
        end)
      end

      if not has_vue_sdk then
        vim.schedule(function()
          vim.notify(
            "Vue TypeScript SDK path not found at " .. vue_typescript_sdk .. ". `vue_ls` will use its defaults.",
            vim.log.levels.WARN,
            { title = "twelve.lsp" }
          )
        end)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("TwelveLspAttach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client and client.server_capabilities then
            client.server_capabilities.semanticTokensProvider = nil
          end
          pcall(vim.lsp.semantic_tokens.enable, false, {
            bufnr = bufnr,
            client_id = client and client.id or nil,
          })

          local opts = { buffer = bufnr }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        end,
      })
    end,
  }),
  use("render-markdown.nvim", "MeanderingProgrammer/render-markdown.nvim", {
    pack = "opt",
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup({
        html = { enabled = false },
        latex = { enabled = false },
        yaml = { enabled = false },
      })
    end,
  }),
  use("mini.nvim", "nvim-mini/mini.nvim", {
    pack = "start",
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
  }),
  use("nvim-nio", "nvim-neotest/nvim-nio", { pack = "opt" }),
  use("FixCursorHold.nvim", "antoinemadec/FixCursorHold.nvim", { pack = "opt" }),
  use("neotest-pest", "V13Axel/neotest-pest", { pack = "opt" }),
  use("neotest", "nvim-neotest/neotest", {
    pack = "opt",
    dependencies = { "nvim-nio", "plenary.nvim", "FixCursorHold.nvim", "neotest-pest" },
    keys = {
      {
        lhs = "<leader>tn",
        desc = "Test nearest",
        rhs = function()
          require("neotest").run.run()
        end,
      },
      {
        lhs = "<leader>tf",
        desc = "Test file",
        rhs = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        lhs = "<leader>T",
        desc = "Test file",
        rhs = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        lhs = "<leader>ta",
        desc = "Test suite",
        rhs = function()
          require("neotest").run.run({ suite = true })
        end,
      },
      {
        lhs = "<leader>tl",
        desc = "Test last",
        rhs = function()
          require("neotest").run.run_last()
        end,
      },
      {
        lhs = "<leader>ts",
        desc = "Test summary",
        rhs = function()
          require("neotest").summary.toggle()
        end,
      },
      {
        lhs = "<leader>to",
        desc = "Test output panel",
        rhs = function()
          require("neotest").output_panel.toggle()
        end,
      },
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-pest"),
        },
      })
    end,
  }),
  use("oil.nvim", "stevearc/oil.nvim", {
    pack = "start",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("oil").setup({
        float = {
          max_height = 0.7,
          max_width = 0.7,
        },
        view_options = {
          show_hidden = true,
        },
        win_options = {
          number = false,
          relativenumber = false,
          statuscolumn = "",
          signcolumn = "yes:2",
          conceallevel = 3,
          concealcursor = "nvic",
        },
      })
    end,
  }),
  use("oil-git-status.nvim", "refractalize/oil-git-status.nvim", {
    pack = "start",
    dependencies = { "oil.nvim" },
    config = function()
      require("oil-git-status").setup()
    end,
  }),
  use("vim-wakatime", "wakatime/vim-wakatime", { pack = "start" }),
  use("text-case.nvim", "johmsalas/text-case.nvim", {
    pack = "start",
    config = function()
      require("textcase").setup({})
    end,
    keys = {
      "ga",
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  }),
  use("which-key.nvim", "folke/which-key.nvim", {
    pack = "opt",
    event = "VimEnter",
    config = function()
      require("which-key").setup({
        preset = "helix",
      })
    end,
  }),
}
