return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
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
  },
  config = function()
    -- ── Helpers: keep only selected capabilities per client ───────────────────────
    local function keep_only(client, wanted_list)
      local wanted = {}
      for _, k in ipairs(wanted_list or {}) do
        wanted[k] = true
      end
      for k, _ in pairs(client.server_capabilities or {}) do
        if k:match("Provider$") and not wanted[k] then
          client.server_capabilities[k] = nil
        end
      end
    end

    -- If you format with Pint/php-cs-fixer/null-ls, keep LS formatting off
    local function disable_fmt(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- If you use nvim-cmp, inherit its capabilities (safe if not installed)
    local capabilities = (function()
      local ok, cmp = pcall(require, "cmp_nvim_lsp")
      return ok and cmp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
    end)()

    vim.lsp.enable("lua_ls")
    vim.lsp.config("intelephense", {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        disable_fmt(client)
        keep_only(client, {
          "completionProvider",
          "hoverProvider",
          "definitionProvider",
          "referencesProvider",
          "documentSymbolProvider",
          "workspaceSymbolProvider",
          "signatureHelpProvider",
          "typeDefinitionProvider",
          "implementationProvider",
          "semanticTokensProvider", -- keep if you want semantic highlights
        })

        -- sample keymaps (buffer-local)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Goto Definition (Intelephense)")
        map("n", "K", vim.lsp.buf.hover, "Hover (Intelephense)")
      end,
      settings = {
        intelephense = {
          telemetry = { enabled = false },
          format = { enable = false },
          files = { maxSize = 5 * 1024 * 1024, associations = { "**/*.php" } },
          environment = { includePaths = { "vendor" } },
        },
      },
    })
    vim.lsp.enable("intelephense")

    vim.lsp.config("phpactor", {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        disable_fmt(client)
        keep_only(client, {
          "codeActionProvider",
          "renameProvider",
        })

        -- local map = function(mode, lhs, rhs, desc)
        --   vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        -- end
        -- map("n", "<leader>cr", vim.lsp.buf.rename, "Rename (Phpactor)")
        -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action (Phpactor)")
      end,
      -- Avoid Phpactor piping diagnostics from phpstan if you run phpstan separately
      init_options = {
        ["language_server_phpstan.enabled"] = false,
      },
    })
    vim.lsp.enable("phpactor")

    -- vim.lsp.enable("biome")
    vim.lsp.enable("gopls")

    local vue_language_server_path = "/usr/lib/node_modules/@vue/language-server"

    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }

    local vtsls_config = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }

    local vue_ls_config = {
      on_init = function(client)
        client.handlers["tsserver/request"] = function(_, result, context)
          local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
          if #clients == 0 then
            vim.notify("Could not find `vtsls` lsp client, `vue_ls` will not work.", vim.log.levels.ERROR)
            return
          end

          local ts_client = clients[1]
          local param = unpack(result or {})
          local id, command, payload = unpack(param or {})

          ts_client:exec_cmd({
            title = "vue_request_forward",
            command = "typescript.tsserverRequest",
            arguments = { command, payload },
          }, { bufnr = context.bufnr }, function(_, r)
            if not r or not r.body then
              vim.notify("vue_ls: failed to forward tsserverRequest", vim.log.levels.WARN)
              return
            end
            client:notify("tsserver/response", { { id, r.body } })
          end)
        end
      end,
    }

    vim.lsp.config("vtsls", vtsls_config)
    vim.lsp.config("vue_ls", vue_ls_config)
    vim.lsp.enable({ "vtsls", "vue_ls" })

    vim.lsp.config("tailwindcss", {
      filetypes = { "javascript", "typescript", "vue", "svelte" },
    })
    vim.lsp.enable("tailwindcss")

    -- vim.lsp.buf.hover({
    --   border = "rounded",
    -- })

    vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  end,
}
