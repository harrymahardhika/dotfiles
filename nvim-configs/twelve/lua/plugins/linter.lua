local use = require("plugin-util").use

return use("nvim-lint", "mfussenegger/nvim-lint", {
  pack = "start",
  config = function()
    local lint = require("lint")
    local uv = vim.uv
    local warned_missing = {}

    local function executable(cmd)
      return vim.fn.executable(cmd) == 1
    end

    local function notify_missing(tool)
      if warned_missing[tool] then
        return
      end
      warned_missing[tool] = true
      vim.schedule(function()
        vim.notify(("Skipping linter, executable not found: %s"):format(tool), vim.log.levels.WARN, {
          title = "twelve.lint",
        })
      end)
    end

    local function first_available(commands)
      for _, cmd in ipairs(commands) do
        if executable(cmd) then
          return cmd
        end
      end
    end

    local function php_root(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      local dir = vim.fs.dirname(path)
      if not dir or dir == "" then
        return uv.cwd()
      end

      local marker = vim.fs.find({ "phpstan.neon", "phpstan.neon.dist", "composer.json", ".git" }, {
        path = dir,
        upward = true,
      })[1]
      return marker and vim.fs.dirname(marker) or dir
    end

    local function normalize_path(path, base)
      if not path or path == "" then
        return nil
      end
      if base and not path:match("^/") then
        path = vim.fs.joinpath(base, path)
      end
      local real = uv.fs_realpath(path)
      return vim.fs.normalize(real or path)
    end

    local phpstan = require("lint.linters.phpstan")
    phpstan.args = {
      "analyze",
      "--error-format=json",
      "--no-progress",
    }
    phpstan.parser = function(output, bufnr)
      if not output or vim.trim(output) == "" then
        return {}
      end

      local ok, decoded = pcall(vim.json.decode, output)
      if not ok or type(decoded) ~= "table" then
        return {}
      end

      local files = decoded.files or {}
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local root = php_root(bufnr)
      local target = normalize_path(bufname)
      local file = files[bufname]

      if not file then
        for key, val in pairs(files) do
          if normalize_path(key, root) == target then
            file = val
            break
          end
        end
      end

      if not file then
        return {}
      end

      local diagnostics = {}
      for _, message in ipairs(file.messages or {}) do
        diagnostics[#diagnostics + 1] = {
          lnum = type(message.line) == "number" and (message.line - 1) or 0,
          col = 0,
          message = message.message,
          source = "phpstan",
          code = message.identifier,
        }
      end
      return diagnostics
    end

    local js_linter = first_available({ "eslint_d", "eslint" })
    local json_linter = first_available({ "jsonlint" })
    local php_linter = executable("phpstan") and "phpstan" or nil

    lint.linters_by_ft = {}
    if js_linter then
      lint.linters_by_ft.javascript = { js_linter }
      lint.linters_by_ft.typescript = { js_linter }
      lint.linters_by_ft.vue = { js_linter }
    end
    if json_linter then
      lint.linters_by_ft.json = { json_linter }
    end
    if php_linter then
      lint.linters_by_ft.php = { php_linter }
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("TwelveLint", { clear = true }),
      callback = function()
        if vim.bo.filetype == "php" then
          if php_linter then
            lint.try_lint("phpstan", { cwd = php_root(0) })
          else
            notify_missing("phpstan")
          end
        else
          local ft = vim.bo.filetype
          local configured = lint.linters_by_ft[ft]
          if configured and #configured > 0 then
            lint.try_lint(configured)
          elseif ft == "javascript" or ft == "typescript" or ft == "vue" then
            notify_missing("eslint_d")
          elseif ft == "json" then
            notify_missing("jsonlint")
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("TwelveLintPhp", { clear = true }),
      pattern = "*.php",
      callback = function()
        if php_linter then
          lint.try_lint("phpstan", { cwd = php_root(0) })
        else
          notify_missing("phpstan")
        end
      end,
    })
  end,
})
