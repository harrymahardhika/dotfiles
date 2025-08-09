return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
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
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = { "rafamadriz/friendly-snippets" },
  --   version = "1.*",
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     keymap = { preset = "default" },
  --     appearance = {
  --       nerd_font_variant = "normal",
  --     },
  --     sources = {
  --       default = { "lsp", "path", "snippets", "buffer" },
  --     },
  --     completion = { documentation = { auto_show = false } },
  --     fuzzy = { implementation = "prefer_rust_with_warning" },
  --   },
  --   opts_extend = { "sources.default" },
  -- },
}
