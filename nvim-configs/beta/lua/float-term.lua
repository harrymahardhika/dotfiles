---@diagnostic disable: undefined-global
local api = vim.api

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local augroup = api.nvim_create_augroup("BetaFloatTerm", { clear = true })

local function compute_geometry(opts)
  opts = opts or {}
  local width_ratio = opts.width_ratio or 0.8
  local height_ratio = opts.height_ratio or 0.8
  local width = opts.width or math.floor(vim.o.columns * width_ratio)
  local height = opts.height or math.floor(vim.o.lines * height_ratio)
  width = math.max(20, math.min(vim.o.columns - 2, width))
  height = math.max(10, math.min(vim.o.lines - 2, height))
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  return {
    width = width,
    height = height,
    col = col,
    row = row,
  }
end

local function apply_window_options(win)
  if not api.nvim_win_is_valid(win) then
    return
  end

  local wo = vim.wo[win]
  wo.number = false
  wo.relativenumber = false
  wo.cursorline = false
  wo.signcolumn = "no"
  wo.scrolloff = 0
  wo.sidescrolloff = 0
  vim.api.nvim_set_option_value("winhighlight", "NormalFloat:Normal,FloatBorder:FloatBorder", { win = win })
end

local function create_floating_window(opts)
  opts = opts or {}
  local geom = compute_geometry(opts)

  local buf
  if opts.buf and api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = geom.width,
    height = geom.height,
    col = geom.col,
    row = geom.row,
    style = "minimal",
    border = opts.border or "rounded",
  }

  local win = api.nvim_open_win(buf, true, win_config)
  apply_window_options(win)
  state.floating.buf = buf
  state.floating.win = win

  return state.floating
end


local function resize_floating_window()
  if not api.nvim_win_is_valid(state.floating.win) then
    return
  end

  local geom = compute_geometry()
  local win_config = {
    relative = "editor",
    width = geom.width,
    height = geom.height,
    col = geom.col,
    row = geom.row,
    style = "minimal",
    border = "rounded",
  }

  api.nvim_win_set_config(state.floating.win, win_config)
  apply_window_options(state.floating.win)
end

local function attach_termclose_autocmd(buf)
  api.nvim_create_autocmd("TermClose", {
    group = augroup,
    buffer = buf,
    once = true,
    callback = function()
      if api.nvim_buf_is_valid(buf) then
        api.nvim_buf_delete(buf, { force = true })
      end
      state.floating.buf = -1
      if api.nvim_win_is_valid(state.floating.win) then
        api.nvim_win_close(state.floating.win, true)
      end
      state.floating.win = -1
    end,
  })
end

local function toggle_terminal()
  if not api.nvim_buf_is_valid(state.floating.buf) then
    state.floating.buf = -1
  end

  if not api.nvim_win_is_valid(state.floating.win) then
    create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      state.floating.buf = api.nvim_get_current_buf()
      -- Set buffer options to allow easy quitting
      vim.bo[state.floating.buf].bufhidden = "hide"
      vim.bo[state.floating.buf].buflisted = false
      attach_termclose_autocmd(state.floating.buf)
    end
    apply_window_options(state.floating.win)
    vim.schedule(function()
      vim.cmd.startinsert()
    end)
  else
    api.nvim_win_hide(state.floating.win)
    state.floating.win = -1
  end
end

api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = resize_floating_window,
})

api.nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function(event)
    local win_id = tonumber(event.match)
    if win_id and win_id == state.floating.win then
      state.floating.win = -1
    end
  end,
})

-- Force close terminal buffers on quit
api.nvim_create_autocmd("QuitPre", {
  group = augroup,
  callback = function()
    -- Close floating terminal window if open
    if api.nvim_win_is_valid(state.floating.win) then
      api.nvim_win_close(state.floating.win, true)
      state.floating.win = -1
    end
    
    -- Force delete terminal buffer if it exists
    if api.nvim_buf_is_valid(state.floating.buf) then
      vim.bo[state.floating.buf].bufhidden = "wipe"
      pcall(api.nvim_buf_delete, state.floating.buf, { force = true })
      state.floating.buf = -1
    end
  end,
})

api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t", "i" }, "<M-m>", toggle_terminal, { desc = "Toggle floating terminal", silent = true })
vim.keymap.set({ "n", "t", "i" }, "<C-\\>", toggle_terminal, { desc = "Toggle floating terminal", silent = true })
