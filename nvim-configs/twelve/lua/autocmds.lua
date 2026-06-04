local api = vim.api
local fn = vim.fn
local autocmd = api.nvim_create_autocmd

autocmd("BufWritePre", {
  group = api.nvim_create_augroup("TwelveTrimWhitespace", { clear = true }),
  pattern = "*",
  callback = function(event)
    local buf = event.buf
    if fn.empty(api.nvim_buf_get_name(buf)) == 1 then
      return
    end

    if not vim.bo[buf].modifiable or vim.bo[buf].binary or vim.bo[buf].buftype ~= "" then
      return
    end

    local max_filesize = 500 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, api.nvim_buf_get_name(buf))
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

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = api.nvim_create_augroup("TwelveAutoReload", { clear = true }),
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

autocmd({ "BufLeave", "FocusLost" }, {
  group = api.nvim_create_augroup("TwelveAutoSave", { clear = true }),
  pattern = "*",
  callback = function(event)
    local buf = event.buf
    if not api.nvim_buf_is_valid(buf) then
      return
    end

    if vim.bo[buf].buftype ~= "" then
      return
    end

    if fn.empty(api.nvim_buf_get_name(buf)) == 1 then
      return
    end

    if not vim.bo[buf].modifiable or vim.bo[buf].readonly or not vim.bo[buf].modified then
      return
    end

    local bufname = api.nvim_buf_get_name(buf)
    vim.cmd("silent! update")
    vim.schedule(function()
      if api.nvim_buf_is_valid(buf) then
        vim.notify(("Auto-saved: %s"):format(bufname), vim.log.levels.INFO, { title = "twelve.autocmd" })
      end
    end)
  end,
})

autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

autocmd("RecordingEnter", {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})

autocmd("RecordingLeave", {
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

autocmd("InsertEnter", {
  group = api.nvim_create_augroup("TwelveRelativeNumberToggle", { clear = true }),
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

autocmd("InsertLeave", {
  group = api.nvim_create_augroup("TwelveRelativeNumberToggle", { clear = false }),
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

api.nvim_create_user_command("BufOnly", function()
  vim.cmd("silent! %bd | e# | bd#")
end, {})
