-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- Increase LSP file size limit to 5MB (default is 1MB)
vim.g.lsp_file_size_limit = 5000000

-- Get capabilities from nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

local nvlsp = require("nvchad.configs.lspconfig")

-- PHP Language Servers
lspconfig.intelephense.setup({
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    intelephense_capabilities(client)
  end,
  on_init = nvlsp.on_init,
  capabilities = capabilities,
})

lspconfig.phpactor.setup({
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    phpactor_capabilities(client)
  end,
  on_init = nvlsp.on_init,
  capabilities = capabilities,
})

-- Go Language Server
lspconfig.gopls.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = capabilities,
})

-- TypeScript/Vue Setup
local vue_language_server_path = "/usr/lib/node_modules/@vue/language-server"
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

local vtsls_config = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
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

lspconfig.vtsls.setup(vtsls_config)

-- Tailwind CSS
lspconfig.tailwindcss.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = capabilities,
  filetypes = { "javascript", "typescript", "vue", "svelte" },
})

-- Vue Language Server (Volar)
lspconfig.volar.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = capabilities,
})

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

