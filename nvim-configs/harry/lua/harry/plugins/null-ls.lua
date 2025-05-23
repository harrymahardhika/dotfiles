return {
  -- "nvimtools/none-ls.nvim",
  -- dependencies = { "nvim-lua/plenary.nvim" },
  -- event = { "BufReadPre", "BufNewFile" },
  -- config = function()
  --   local null_ls = require("null-ls")
  --   local builtins = null_ls.builtins
  --
  --   null_ls.setup({
  --     sources = {
  --       -- Laravel Pint: only run if pint.json or vendor/bin/pint exists
  --       builtins.formatting.pint.with({
  --         condition = function(utils)
  --           return utils.root_has_file({ "pint.json", "vendor/bin/pint" })
  --         end,
  --       }),
  --
  --       -- Prettierd: only if prettier config exists
  --       builtins.formatting.prettierd.with({
  --         condition = function(utils)
  --           return utils.root_has_file({
  --             ".prettierrc",
  --             ".prettierrc.js",
  --             ".prettierrc.json",
  --             "prettier.config.js",
  --             ".prettierignore",
  --           })
  --         end,
  --       }),
  --
  --       -- Stylua: only if stylua.toml or .stylua.toml exists
  --       builtins.formatting.stylua.with({
  --         condition = function(utils)
  --           return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
  --         end,
  --       }),
  --     },
  --
  --     on_attach = function(client, bufnr)
  --       if client.supports_method("textDocument/formatting") then
  --         vim.api.nvim_create_autocmd("BufWritePre", {
  --           group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
  --           buffer = bufnr,
  --           callback = function()
  --             vim.lsp.buf.format({ bufnr = bufnr })
  --           end,
  --         })
  --       end
  --     end,
  --   })
  -- end,
}
