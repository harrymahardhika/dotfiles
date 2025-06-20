return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      }
    },
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({})
      lspconfig.intelephense.setup({})
      lspconfig.phpactor.setup({})
      lspconfig.biome.setup({})
      lspconfig.gopls.setup({})

      -- local vue_ls_path = vim.fn.expand("$HOME/.nvm/versions/node/v20.18.1/bin/vue-language-server")
      -- lspconfig.ts_ls.setup {
      --   init_options = {
      --     plugins = {
      --       {
      --         name = "@vue/typescript-plugin",
      --         location = vue_ls_path,
      --         languages = { "javascript", "typescript", "vue" },
      --       },
      --     },
      --   },
      -- }

      lspconfig.vue_ls.setup({
        filetypes = { "javascript", "typescript", "vue", },
        init_options = {
          vue = {
            hybridMode = false,
          },
          typescript = {
            tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
          }
        },
      })

      lspconfig.tailwindcss.setup({
        filetypes = { "javascript", "typescript", "vue", "svelte" },
      })

      -- mapping for LSP
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

      -- cmp setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  }
}
