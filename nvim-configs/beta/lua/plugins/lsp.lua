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
    -- Increase LSP file size limit to 5MB (default is 1MB)
    vim.g.lsp_file_size_limit = 5000000

    -- Get capabilities from nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
    local vue_language_server_path = "/usr/lib/node_modules/@vue/language-server"
    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }

    local vtsls_config = {
      capabilities = capabilities,
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
        typescript = {
          preferences = {
            importModuleSpecifier = "relative",
            importModuleSpecifierEnding = "minimal",
          },
          tsserver = {
            maxTsServerMemory = 8192,
          },
        },
        javascript = {
          preferences = {
            importModuleSpecifier = "relative",
            importModuleSpecifierEnding = "minimal",
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }

    vim.lsp.config("vtsls", vtsls_config)
    vim.lsp.enable("vtsls")

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
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      end,
    })
  end,
}
