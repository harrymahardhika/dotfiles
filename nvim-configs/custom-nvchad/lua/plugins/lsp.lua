return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
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
    -- Increase LSP file size limit to 5MB (default is 1MB)
    vim.g.lsp_file_size_limit = 5000000

    -- Performance: Reduce LSP log level
    vim.lsp.set_log_level("ERROR")

    -- Get capabilities from nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Disable semantic tokens to prevent conflicts with treesitter highlighting
    capabilities.textDocument.semanticTokens = vim.NIL

    -- Helper functions for LSP capability management
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

    -- Lua Language Server
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    -- PHP Language Servers
    vim.lsp.config("intelephense", {
      on_attach = intelephense_capabilities,
      capabilities = capabilities,
    })
    vim.lsp.enable("intelephense")

    vim.lsp.config("phpactor", {
      on_attach = phpactor_capabilities,
      capabilities = capabilities,
    })
    vim.lsp.enable("phpactor")

    -- Go Language Server
    vim.lsp.config("gopls", {
      capabilities = capabilities,
    })
    vim.lsp.enable("gopls")

    -- TypeScript/Vue Setup
    local function node_modules_root()
      if vim.fn.executable("pnpm") == 1 then
        local root = vim.fn.system("pnpm root -g"):gsub("%s+$", "")
        if vim.v.shell_error == 0 and root ~= "" then
          return root
        end
      end
      return "/usr/lib/node_modules"
    end

    local npm_root = node_modules_root()
    local vue_language_server_path = npm_root .. "/@vue/language-server"
    local vtsls_typescript_lib_path = npm_root .. "/@vtsls/language-server/node_modules/typescript/lib"

    -- vtsls for TypeScript/JavaScript/Vue
    local vtsls_config = {
      capabilities = capabilities,
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              },
            },
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
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }

    vim.lsp.config("vtsls", vtsls_config)
    vim.lsp.enable("vtsls")

    -- Vue Language Server (requires vtsls to be running)
    vim.lsp.config("vue_ls", {
      capabilities = capabilities,
      filetypes = { "vue" },
      init_options = {
        typescript = {
          tsdk = vtsls_typescript_lib_path,
        },
      },
    })
    vim.lsp.enable("vue_ls")

    -- Tailwind CSS
    vim.lsp.config("tailwindcss", {
      capabilities = capabilities,
      filetypes = { "javascript", "typescript", "vue", "svelte" },
    })
    vim.lsp.enable("tailwindcss")

    -- Biome (commented out)
    -- vim.lsp.enable("biome")

    -- LSP Keymaps on attach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        if client and client.server_capabilities then
          client.server_capabilities.semanticTokensProvider = nil
        end
        -- Some servers may have already started semantic token streams;
        -- stop them explicitly so Tree-sitter/Catppuccin colors remain authoritative.
        pcall(vim.lsp.semantic_tokens.stop, bufnr, client and client.id or nil)

        local opts = { buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        -- Note: gd, gR, gi, gt are mapped to fzf-lua LSP pickers in fzf-lua.lua
      end,
    })
  end,
}
