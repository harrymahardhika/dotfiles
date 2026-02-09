---@diagnostic disable: undefined-global
local api = vim.api
local fn = vim.fn
local autocmd = api.nvim_create_autocmd

-- remove trailing whitespace before saving (skip special buffers)
autocmd("BufWritePre", {
  group = api.nvim_create_augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  callback = function(event)
    local buf = event.buf
    if fn.empty(api.nvim_buf_get_name(buf)) == 1 then
      return
    end

    if not vim.bo[buf].modifiable or vim.bo[buf].binary or vim.bo[buf].buftype ~= "" then
      return
    end

    -- Performance: Skip for large files
    local max_filesize = 500 * 1024 -- 500 KB
    local ok, stats = pcall(vim.loop.fs_stat, api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    local view = fn.winsaveview()
    api.nvim_buf_call(buf, function()
      vim.cmd([[silent! keeppatterns %s/\s\+$//e]])
    end)
    fn.winrestview(view)
  end,
})

-- auto-reload files only when focus changes (avoids insert-mode hiccups)
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = api.nvim_create_augroup("AutoReload", { clear = true }),
  callback = function()
    if fn.getcmdwintype() ~= "" then
      return
    end

    local buf = api.nvim_get_current_buf()
    if vim.bo[buf].buftype == "" then
      local stat = fn.getftype(api.nvim_buf_get_name(buf))
      if stat == "file" then
        vim.cmd.checktime()
      end
    end
  end,
})

-- set php commentstring to use double-slash comments
autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.bo.commentstring = "// %s" -- Use double-slash comments by default
  end,
})

-- set cmdheight to 1 when recording macros
autocmd("RecordingEnter", {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})

-- set cmdheight to 0 when leaving recording macros
autocmd("RecordingLeave", {
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

-- Performance: Disable relative numbers in insert mode
autocmd("InsertEnter", {
  group = api.nvim_create_augroup("RelativeNumberToggle", { clear = true }),
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

autocmd("InsertLeave", {
  group = api.nvim_create_augroup("RelativeNumberToggle", { clear = false }),
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

api.nvim_create_user_command("BufOnly", function()
  vim.cmd("silent! %bd | e# | bd#")
end, {})

