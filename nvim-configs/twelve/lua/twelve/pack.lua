local uv = vim.uv

local M = {}

local specs = require("twelve.plugins")
local by_name = {}
local loaded = {}
local configured = {}
local initialized = false
local startup = {
  started_at = uv.hrtime(),
  finished_at = nil,
  phases = {},
  plugins = {},
}

local data_root = vim.fn.stdpath("data") .. "/site/pack/twelve"
local start_root = data_root .. "/start"
local opt_root = data_root .. "/opt"

local disabled_plugins = {
  "2html_plugin",
  "tohtml",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
}

for _, plugin in ipairs(disabled_plugins) do
  vim.g["loaded_" .. plugin] = 1
end

local function plugin_path(spec)
  local root = spec.pack == "opt" and opt_root or start_root
  return root .. "/" .. spec.name
end

local function is_installed(spec)
  return uv.fs_stat(plugin_path(spec)) ~= nil
end

local function sort_specs(items)
  table.sort(items, function(a, b)
    local pa = a.priority or 0
    local pb = b.priority or 0
    if pa == pb then
      return a.name < b.name
    end
    return pa > pb
  end)
  return items
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "twelve.pack" })
end

local function now_ms()
  return uv.hrtime() / 1e6
end

local function elapsed_ms(started_at)
  return (uv.hrtime() - started_at) / 1e6
end

local function round_ms(ms)
  return tonumber(string.format("%.2f", ms))
end

local function plugin_profile(name)
  local profile = startup.plugins[name]
  if not profile then
    profile = {
      load_ms = 0,
      config_ms = 0,
      total_ms = 0,
      count = 0,
    }
    startup.plugins[name] = profile
  end
  return profile
end

local function record_phase(name, started_at)
  startup.phases[#startup.phases + 1] = {
    name = name,
    ms = elapsed_ms(started_at),
  }
end

local function progress(message, idx, total, opts)
  opts = opts or {}
  if opts.quiet then
    return
  end
  local prefix = total and ("[%d/%d] "):format(idx, total) or ""
  notify(prefix .. message)
end

local function scratch_report(title, lines)
  vim.cmd("new")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_name(buf, title)
end

local function run_git(args)
  local out = vim.fn.system(args)
  if vim.v.shell_error ~= 0 then
    error(table.concat(args, " ") .. "\n" .. out)
  end
  return out
end

local function ensure_directories()
  vim.fn.mkdir(start_root, "p")
  vim.fn.mkdir(opt_root, "p")
end

local function install(spec)
  if is_installed(spec) then
    return false
  end

  local url = ("https://github.com/%s.git"):format(spec.repo)
  run_git({ "git", "clone", "--filter=blob:none", "--depth=1", url, plugin_path(spec) })

  if spec.build then
    pcall(vim.cmd, spec.build)
  end

  return true
end

local function run_config(spec)
  if configured[spec.name] or not spec.config then
    configured[spec.name] = true
    return
  end

  configured[spec.name] = true
  local started_at = uv.hrtime()
  local ok, err = pcall(spec.config)
  local took_ms = elapsed_ms(started_at)
  local profile = plugin_profile(spec.name)
  profile.config_ms = profile.config_ms + took_ms
  profile.total_ms = profile.total_ms + took_ms
  if not ok then
    notify(("config failed for %s: %s"):format(spec.name, err), vim.log.levels.ERROR)
  end
end

local function load_plugin(name)
  if loaded[name] then
    return
  end

  local spec = by_name[name]
  if not spec then
    return
  end

  for _, dep in ipairs(spec.dependencies or {}) do
    load_plugin(dep)
  end

  local started_at = uv.hrtime()
  if spec.pack == "opt" then
    vim.cmd.packadd(spec.name)
  else
    pcall(vim.cmd.packadd, spec.name)
  end
  local took_ms = elapsed_ms(started_at)

  loaded[name] = true
  local profile = plugin_profile(spec.name)
  profile.load_ms = profile.load_ms + took_ms
  profile.total_ms = profile.total_ms + took_ms
  profile.count = profile.count + 1
  run_config(spec)
end

local function install_missing(opts)
  opts = opts or {}
  local started_at = uv.hrtime()
  ensure_directories()

  local installed_any = false
  local total = #specs
  for idx, spec in ipairs(specs) do
    progress("checking " .. spec.name, idx, total, opts)
    if install(spec) then
      installed_any = true
      if not opts.quiet then
        notify(("installed %s"):format(spec.name))
      end
    end
  end

  if installed_any then
    vim.cmd.packloadall({ bang = true })
  end

  record_phase("install_missing", started_at)
end

local function setup_init()
  local started_at = uv.hrtime()
  for _, spec in ipairs(specs) do
    if spec.init then
      local ok, err = pcall(spec.init)
      if not ok then
        notify(("init failed for %s: %s"):format(spec.name, err), vim.log.levels.ERROR)
      end
    end
  end
  record_phase("setup_init", started_at)
end

local function setup_start_plugins()
  local started_at = uv.hrtime()
  local start_specs = {}
  for _, spec in ipairs(specs) do
    if spec.pack ~= "opt" then
      start_specs[#start_specs + 1] = spec
    end
  end

  for _, spec in ipairs(sort_specs(start_specs)) do
    load_plugin(spec.name)
  end
  record_phase("setup_start_plugins", started_at)
end

local function once_autocmd(events, group_name, callback)
  local group = vim.api.nvim_create_augroup(group_name, { clear = true })
  vim.api.nvim_create_autocmd(events, {
    group = group,
    callback = function(args)
      callback(args)
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end,
  })
end

local function setup_lazy_events(spec)
  if spec.event then
    local events = type(spec.event) == "table" and spec.event or { spec.event }
    once_autocmd(events, "TwelvePackEvent_" .. spec.name, function()
      load_plugin(spec.name)
    end)
  end

  if spec.ft then
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TwelvePackFt_" .. spec.name, { clear = true }),
      pattern = spec.ft,
      callback = function()
        load_plugin(spec.name)
      end,
      once = true,
    })
  end

  if spec.cmd then
    vim.api.nvim_create_autocmd("CmdUndefined", {
      group = vim.api.nvim_create_augroup("TwelvePackCmd_" .. spec.name, { clear = true }),
      pattern = spec.cmd,
      callback = function(args)
        load_plugin(spec.name)
        local command = args.match
        local line = vim.fn.getcmdline()
        vim.schedule(function()
          if line ~= "" then
            vim.cmd(command .. " " .. line)
          else
            vim.cmd(command)
          end
        end)
      end,
    })
  end

  if spec.keys then
    for _, key in ipairs(spec.keys) do
      local mode = key.mode or "n"
      vim.keymap.set(mode, key.lhs, function()
        load_plugin(spec.name)
        if type(key.rhs) == "function" then
          key.rhs()
        elseif type(key.rhs) == "string" then
          vim.cmd(key.rhs)
        end
      end, { desc = key.desc, silent = key.silent ~= false })
    end
  end
end

local function clean()
  local started_at = uv.hrtime()
  local keep = {}
  for _, spec in ipairs(specs) do
    keep[plugin_path(spec)] = true
  end

  local removed = 0
  for _, root in ipairs({ start_root, opt_root }) do
    local handle = uv.fs_scandir(root)
    if handle then
      while true do
        local name = uv.fs_scandir_next(handle)
        if not name then
          break
        end
        local path = root .. "/" .. name
        if not keep[path] then
          vim.fn.delete(path, "rf")
          removed = removed + 1
        end
      end
    end
  end

  record_phase("clean", started_at)
  notify(("removed %d unused plugin(s)"):format(removed))
end

local function update(opts)
  opts = opts or {}
  local started_at = uv.hrtime()
  local updated = 0
  local total = #specs
  for idx, spec in ipairs(specs) do
    if is_installed(spec) then
      progress("updating " .. spec.name, idx, total, opts)
      run_git({ "git", "-C", plugin_path(spec), "pull", "--ff-only" })
      if spec.build then
        pcall(vim.cmd, spec.build)
      end
      updated = updated + 1
    end
  end
  record_phase("update", started_at)
  notify(("updated %d plugin(s)"):format(updated))
end

local function status()
  local lines = {}
  for _, spec in ipairs(sort_specs(vim.deepcopy(specs))) do
    local state = is_installed(spec) and "installed" or "missing"
    local mode = spec.pack == "opt" and "opt" or "start"
    lines[#lines + 1] = ("%s [%s] %s"):format(spec.name, mode, state)
  end
  notify(table.concat(lines, "\n"))
end

local function profile_report()
  startup.finished_at = startup.finished_at or now_ms()

  local plugin_rows = {}
  for name, profile in pairs(startup.plugins) do
    plugin_rows[#plugin_rows + 1] = {
      name = name,
      load_ms = round_ms(profile.load_ms),
      config_ms = round_ms(profile.config_ms),
      total_ms = round_ms(profile.total_ms),
      count = profile.count,
    }
  end

  table.sort(plugin_rows, function(a, b)
    if a.total_ms == b.total_ms then
      return a.name < b.name
    end
    return a.total_ms > b.total_ms
  end)

  local lines = {
    "# twelve startup profile",
    "",
    ("Total setup time: %.2f ms"):format(round_ms(startup.finished_at - (startup.started_at / 1e6))),
    "",
    "## phases",
  }

  for _, phase in ipairs(startup.phases) do
    lines[#lines + 1] = ("- %s: %.2f ms"):format(phase.name, round_ms(phase.ms))
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "## plugins"
  lines[#lines + 1] = "| plugin | load ms | config ms | total ms | loads |"
  lines[#lines + 1] = "| --- | ---: | ---: | ---: | ---: |"

  for _, row in ipairs(plugin_rows) do
    lines[#lines + 1] = ("| %s | %.2f | %.2f | %.2f | %d |"):format(
      row.name,
      row.load_ms,
      row.config_ms,
      row.total_ms,
      row.count
    )
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "For full Neovim loader timing, run `nvim --startuptime /tmp/nvim-startup.log`."

  scratch_report("twelve://profile", lines)
end

local function define_commands()
  vim.api.nvim_create_user_command("PackInstall", function()
    install_missing()
    notify("install complete")
  end, {})

  vim.api.nvim_create_user_command("PackUpdate", update, {})
  vim.api.nvim_create_user_command("PackClean", clean, {})
  vim.api.nvim_create_user_command("PackStatus", status, {})
  vim.api.nvim_create_user_command("PackProfile", profile_report, {})
  vim.api.nvim_create_user_command("PackSync", function()
    install_missing()
    update()
    clean()
  end, {})
end

function M.setup()
  if initialized then
    return
  end
  initialized = true

  for _, spec in ipairs(specs) do
    by_name[spec.name] = spec
  end

  define_commands()
  setup_init()
  install_missing({ quiet = true })
  setup_start_plugins()
  startup.finished_at = now_ms()

  for _, spec in ipairs(specs) do
    if spec.pack == "opt" then
      setup_lazy_events(spec)
    end
  end
end

return M
