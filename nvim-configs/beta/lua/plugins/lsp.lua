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
      },
    },
    config = function()
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("intelephense")
      vim.lsp.enable("phpactor")
      vim.lsp.enable("biome")
      vim.lsp.enable("gopls")

      -- configuration for vue-language-server 2.2.x
      vim.lsp.config("vue_ls", {
        filetypes = { "javascript", "typescript", "vue" },
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      })
      -- TODO: setup for vue-language-server 3.x

      vim.lsp.enable("vue_ls")

      vim.lsp.config("tailwindcss", {
        filetypes = { "javascript", "typescript", "vue", "svelte" },
      })
      vim.lsp.enable("tailwindcss")

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
  },
}
