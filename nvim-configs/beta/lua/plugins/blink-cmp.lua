return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = "rafamadriz/friendly-snippets",
    version = "1.*",

    opts = {
      -- 'default' for mappings preset (closest to Neovim defaults)
      keymap = {
        preset = "default",
        -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        -- ['<C-e>'] = { 'hide' },
        -- ['<C-y>'] = { 'select_and_accept' },
        --
        -- ['<C-p>'] = { 'select_prev', 'fallback' },
        -- ['<C-n>'] = { 'select_next', 'fallback' },
        --
        -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        -- Tab: navigate completion menu, or jump through snippets, or fallback to normal tab
        -- ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        -- ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },

      signature = {
        enabled = true,
      },
    },
  },
}
