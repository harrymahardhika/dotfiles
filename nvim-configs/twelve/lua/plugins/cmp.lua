local use = require("plugin-util").use

return {
  use("nvim-cmp", "hrsh7th/nvim-cmp", {
    pack = "opt",
    event = "InsertEnter",
    dependencies = { "cmp-nvim-lsp", "cmp-buffer", "LuaSnip", "cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- after/plugin files don't run for mid-session packadd, so M.setup() in
      -- cmp-nvim-lsp's after/plugin is never called. Bootstrap it manually.
      local ok_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        performance = {
          debounce = 150,
          throttle = 60,
          fetching_timeout = 500,
          filtering_context_budget = 200,
          confirm_resolve_timeout = 100,
          async_budget = 1,
          max_view_entries = 50,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          {
            name = "buffer",
            priority = 500,
            keyword_length = 3,
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
        },
      })

      if ok_lsp then
        cmp_lsp.setup()
        cmp_lsp._on_insert_enter()
      end
    end,
  }),
  use("cmp-nvim-lsp", "hrsh7th/cmp-nvim-lsp", { pack = "opt" }),
  use("cmp-buffer", "hrsh7th/cmp-buffer", { pack = "opt" }),
  use("LuaSnip", "L3MON4D3/LuaSnip", { pack = "opt" }),
  use("cmp_luasnip", "saadparwaiz1/cmp_luasnip", { pack = "opt" }),
}
