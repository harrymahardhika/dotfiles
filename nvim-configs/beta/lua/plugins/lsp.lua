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
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("intelephense")
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

    vim.lsp.buf.hover({
      border = "rounded",
    })

    vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  end,
}
