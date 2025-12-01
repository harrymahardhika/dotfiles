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

    -- Helper functions for LSP capability management
    local function disable_navigation_capabilities(client)
      local capabilities = client.server_capabilities or {}
      capabilities.definitionProvider = nil
      capabilities.typeDefinitionProvider = nil
      capabilities.declarationProvider = nil
      capabilities.implementationProvider = nil
    end

    local function limit_phpactor_capabilities(client)
      local capabilities = client.server_capabilities or {}
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

      for _, capability in ipairs(vim.tbl_keys(capabilities)) do
        if capability:find("Provider", 1, true) and not allowed[capability] then
          capabilities[capability] = nil
        end
      end
    end

    -- Lua Language Server
    vim.lsp.enable("lua_ls")

    -- PHP Language Servers
    vim.lsp.config("intelephense", {
      on_attach = disable_navigation_capabilities,
    })
    vim.lsp.enable("intelephense")

    vim.lsp.config("phpactor", {
      on_attach = limit_phpactor_capabilities,
    })
    vim.lsp.enable("phpactor")

    -- vim.lsp.enable("phptools")

    -- Go Language Server
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
    vim.lsp.config("vue_ls", {})
    vim.lsp.enable({ "vtsls", "vue_ls" })

    -- Tailwind CSS
    vim.lsp.config("tailwindcss", {
      filetypes = { "javascript", "typescript", "vue", "svelte" },
    })
    vim.lsp.enable("tailwindcss")

    -- Biome (commented out)
    -- vim.lsp.enable("biome")

    -- LSP Keymaps
    -- vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true })
  end,
}
