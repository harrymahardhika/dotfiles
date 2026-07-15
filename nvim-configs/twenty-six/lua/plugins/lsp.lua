return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
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

    -- Performance: Reduce LSP log level
    vim.lsp.log.set_level("ERROR")

    -- No completion plugin: use Neovim's built-in vim.lsp.completion (0.11+)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Disable semantic tokens to prevent conflicts with treesitter highlighting
    capabilities.textDocument.semanticTokens = nil

    local missing_servers = {}

    local function executable_exists(cmd)
      return vim.fn.executable(cmd) == 1
    end

    local vue_root_markers = {
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      "vite.config.ts",
      "vite.config.js",
      "nuxt.config.ts",
      "nuxt.config.js",
      ".git",
    }

    local function project_root(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, vue_root_markers) or vim.fn.getcwd())
    end

    local function record_missing(server, cmd)
      missing_servers[#missing_servers + 1] = ("%s (%s)"):format(server, cmd)
    end

    local function enable_server(server, opts)
      opts = opts or {}
      local cmd = opts.cmd
      local exe = type(cmd) == "table" and cmd[1] or cmd

      local config = vim.deepcopy(opts)
      if type(cmd) == "string" then
        -- Plain executable name: only used for the existence check below,
        -- let nvim-lspconfig supply its own default cmd table.
        config.cmd = nil
      end

      vim.lsp.config(server, config)

      if exe and not executable_exists(exe) then
        record_missing(server, exe)
        return
      end

      vim.lsp.enable(server)
    end

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

    -- Lua Language Server
    enable_server("lua_ls", {
      cmd = "lua-language-server",
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    -- PHP Language Servers
    enable_server("intelephense", {
      cmd = "intelephense",
      on_attach = intelephense_capabilities,
      capabilities = capabilities,
    })

    enable_server("phpactor", {
      cmd = "phpactor",
      on_attach = phpactor_capabilities,
      capabilities = capabilities,
    })

    -- Go Language Server
    enable_server("gopls", {
      cmd = "gopls",
      capabilities = capabilities,
    })

    -- TypeScript/Vue Setup
    --
    -- pnpm bin -g is slow (~300-900ms); run it once and share across all lookups.
    local pnpm_bin = (function()
      local r = vim.fn.trim(vim.fn.system("pnpm bin -g 2>/dev/null"))
      return (vim.v.shell_error == 0 and r ~= "") and r or nil
    end)()

    local function pnpm_global_root(bin_name)
      if not pnpm_bin then
        return nil
      end
      local wrapper = pnpm_bin .. "/" .. bin_name
      if not vim.uv.fs_stat(wrapper) then
        return nil
      end
      local line =
        vim.fn.trim(vim.fn.system("grep -o 'cmd-shim-target=.*' " .. vim.fn.shellescape(wrapper) .. " 2>/dev/null"))
      local target = line:match("cmd%-shim%-target=(.+)")
      if not target then
        return nil
      end
      return vim.fn.fnamemodify(vim.fn.trim(target), ":h:h")
    end

    local npm_global = vim.fn.trim(vim.fn.system("npm root -g 2>/dev/null"))
    local vue_language_server_path = pnpm_global_root("vue-language-server")
      or (npm_global ~= "" and npm_global .. "/@vue/language-server" or nil)
      or "/usr/lib/node_modules/@vue/language-server"

    -- @vue/typescript-plugin must be resolvable from `location`. With npm it sits
    -- as a sibling in node_modules/@vue/; with pnpm it lands in .pnpm/node_modules.
    local function find_vue_ts_plugin(vue_ls_path)
      local node_modules = vim.fn.fnamemodify(vue_ls_path, ":h:h")
      local pnpm_path = node_modules .. "/.pnpm/node_modules/@vue/typescript-plugin"
      if vim.uv.fs_stat(pnpm_path) then
        return pnpm_path
      end
      local npm_path = node_modules .. "/@vue/typescript-plugin"
      if vim.uv.fs_stat(npm_path) then
        return npm_path
      end
      return vue_ls_path
    end

    local vue_ts_plugin_path = find_vue_ts_plugin(vue_language_server_path)

    local ts_root = pnpm_global_root("tsc") or (npm_global ~= "" and npm_global .. "/typescript" or nil)
    local vue_typescript_sdk = ts_root and (ts_root .. "/lib") or nil
    local has_vue_plugin = vim.uv.fs_stat(vue_language_server_path) ~= nil
    local has_vue_sdk = vue_typescript_sdk ~= nil and vim.uv.fs_stat(vue_typescript_sdk) ~= nil
    local vtsls_settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {},
        },
      },
      typescript = {
        preferences = {
          importModuleSpecifier = "non-relative",
          importModuleSpecifierEnding = "minimal",
        },
        tsserver = {
          maxTsServerMemory = 8192,
        },
      },
      javascript = {
        preferences = {
          importModuleSpecifier = "non-relative",
          importModuleSpecifierEnding = "minimal",
        },
      },
    }

    if has_vue_plugin then
      table.insert(vtsls_settings.vtsls.tsserver.globalPlugins, {
        name = "@vue/typescript-plugin",
        location = vue_ts_plugin_path,
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      })
    end

    enable_server("vtsls", {
      cmd = "vtsls",
      capabilities = capabilities,
      settings = vtsls_settings,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      root_dir = project_root,
    })

    -- Vue Language Server (requires vtsls to be running).
    --
    -- NOTE: this version of @vue/language-server only reads the TS SDK from
    -- a `--tsdk=` CLI arg (checked against process.argv in its bootstrap),
    -- NOT from init_options.typescript.tsdk. Without it, it falls back to
    -- `require('typescript')` resolved from its own install location, which
    -- can land on an unrelated/incompatible typescript package and crash
    -- with "Cannot read properties of undefined (reading 'protocol')".
    enable_server("vue_ls", {
      cmd = has_vue_sdk and { "vue-language-server", "--stdio", "--tsdk=" .. vue_typescript_sdk }
        or "vue-language-server",
      capabilities = capabilities,
      filetypes = { "vue" },
      root_dir = project_root,
    })

    -- Tailwind CSS
    enable_server("tailwindcss", {
      cmd = "tailwindcss-language-server",
      capabilities = capabilities,
      filetypes = { "javascript", "typescript", "vue", "svelte" },
      root_dir = project_root,
    })

    -- Biome (commented out)
    -- vim.lsp.enable("biome")

    -- vim.lsp.enable("harper_ls")

    if #missing_servers > 0 then
      vim.schedule(function()
        vim.notify(
          "Skipped LSP servers with missing executables: " .. table.concat(missing_servers, ", "),
          vim.log.levels.WARN,
          { title = "lsp" }
        )
      end)
    end

    if not has_vue_plugin then
      vim.schedule(function()
        vim.notify(
          "Vue TypeScript plugin path not found at "
            .. vue_language_server_path
            .. ". Vue hybrid mode is disabled until it is installed.",
          vim.log.levels.WARN,
          { title = "lsp" }
        )
      end)
    end

    if not has_vue_sdk then
      vim.schedule(function()
        vim.notify(
          "Vue TypeScript SDK path not found at " .. tostring(vue_typescript_sdk) .. ". `vue_ls` will use its defaults.",
          vim.log.levels.WARN,
          { title = "lsp" }
        )
      end)
    end

    -- LSP Keymaps on attach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("TwentySixLspAttach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        if client and client.server_capabilities then
          client.server_capabilities.semanticTokensProvider = nil
        end
        -- Some servers may have already started semantic token streams;
        -- stop them explicitly so Tree-sitter/Catppuccin colors remain authoritative.
        pcall(vim.lsp.semantic_tokens.enable, false, { bufnr = bufnr, client_id = client and client.id or nil })

        -- Native completion (no nvim-cmp): trigger automatically on typing
        if client and client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        local opts = { buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        -- Note: gd is mapped to fzf.lsp_definitions in fzf-lua.lua
      end,
    })
  end,
}
