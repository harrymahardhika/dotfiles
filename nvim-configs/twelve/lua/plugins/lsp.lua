local use = require("plugin-util").use

return {
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
      capabilities.textDocument.semanticTokens = nil
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
            "Vue TypeScript plugin path not found at "
              .. vue_language_server_path
              .. ". Vue hybrid mode is disabled until it is installed.",
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
}
