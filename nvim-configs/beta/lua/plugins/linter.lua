return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local uv = vim.uv

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

    lint.linters_by_ft = {
      -- javascript = { "biomejs" },
      -- typescript = { "biomejs" },
      -- vue = { "biomejs" },
      javascript = { "eslint_d" },
      json = { "jsonlint" },
      php = { "phpstan" },
      typescript = { "eslint_d" },
      vue = { "eslint_d" },
    }

    -- Run linting on save, open, and after leaving insert mode
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      callback = function()
        if vim.bo.filetype == "php" then
          lint.try_lint("phpstan", { cwd = php_root(0) })
        else
          lint.try_lint()
        end
      end,
    })

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      pattern = "*.php",
      callback = function()
        lint.try_lint("phpstan", { cwd = php_root(0) })
      end,
    })
  end,
}
