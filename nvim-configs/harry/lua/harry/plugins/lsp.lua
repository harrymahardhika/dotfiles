return {
  { "VonHeikemen/lsp-zero.nvim", branch = "v4.x", lazy = true,   config = false, },
  { "williamboman/mason.nvim",   lazy = false,    config = true, },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          { name = "path" },
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer",  keyword_length = 3 },
        },

        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
        }),

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        }
      })
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      local lsp_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        local telescope_builtin = require("telescope.builtin")
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, opts)
        -- vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, opts)
        vim.keymap.set("n", "go", telescope_builtin.lsp_type_definitions, opts)
        vim.keymap.set("n", "gr", telescope_builtin.lsp_references, opts)
        -- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.keymap.set({ "n", "x" }, "<leader>cf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "intelephense"
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})

            local mason_registry = require("mason-registry")
            local lspconfig = require("lspconfig")

            -- intelephense
            lspconfig.intelephense.setup({
              root_dir = function()
                return vim.loop.cwd()
              end,
              settings = {
                intelephense = {
                  stubs = {
                    "Core",
                    "ctype",
                    "curl",
                    "date",
                    "dom",
                    "fileinfo",
                    "filter",
                    "gd",
                    "hash",
                    "iconv",
                    "igbinary",
                    "imagick",
                    "json",
                    "libxml",
                    "mbstring",
                    "mysqlnd",
                    "openssl",
                    "pcntl",
                    "pcre",
                    "PDO",
                    "pdo_pgsql",
                    "pdo_sqlite",
                    "pgsql",
                    "Phar",
                    "posix",
                    "random",
                    "readline",
                    "redis",
                    "Reflection",
                    "session",
                    "SimpleXML",
                    "SPL",
                    "sqlite3",
                    "standard",
                    "tokenizer",
                    "xml",
                    "xmlreader",
                    "xmlwriter",
                    "Zend OPcache",
                    "zip",
                    "zlib",
                  },
                  -- environment = {
                  --   includePaths = {
                  --     "~/.composer/vendor/php-stubs/",
                  --     "~/.composer/vendor/wpsyntex/"
                  --   }
                  -- },
                  files = {
                    maxSize = 5000000,
                  },
                }
              }

            })
            -- vue/volar
            local vue_lsp_path = mason_registry.get_package("vue-language-server"):get_install_path() ..
                "/node_modules/@vue/language-server"

            lspconfig.ts_ls.setup {
              init_options = {
                plugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vue_lsp_path,
                    languages = { "vue" },
                  },
                },
              },
              filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            }

            lspconfig.lua_ls.setup {
              on_init = function(client)
                if client.workspace_folders then
                  local path = client.workspace_folders[1].name
                  if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    return
                  end
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME
                      -- Depending on the usage, you might want to add additional paths here.
                      -- "${3rd}/luv/library"
                      -- "${3rd}/busted/library",
                    }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                    -- library = vim.api.nvim_get_runtime_file("", true)
                  }
                })
              end,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { 'vim' }
                  }
                }
              }
            }
          end,
        }
      })
    end
  }
}
