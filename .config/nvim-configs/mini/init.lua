-- mini.deps
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  require("mini.ai").setup()
end)

later(function()
  require("mini.clue").setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      { mode = "n", keys = "\\" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    clues = {
      { mode = "n", keys = "<Leader>b", desc = " Buffer" },
      { mode = "n", keys = "<Leader>f", desc = " Find" },
      { mode = "n", keys = "<Leader>g", desc = "󰊢 Git" },
      { mode = "n", keys = "<Leader>i", desc = "󰏪 Insert" },
      { mode = "n", keys = "<Leader>l", desc = "󰘦 LSP" },
      { mode = "n", keys = "<Leader>q", desc = " NVim" },
      { mode = "n", keys = "<Leader>s", desc = "󰆓 Session" },
      { mode = "n", keys = "<Leader>u", desc = "󰔃 UI" },
      { mode = "n", keys = "<Leader>w", desc = " Window" },
      require("mini.clue").gen_clues.g(),
      require("mini.clue").gen_clues.builtin_completion(),
      require("mini.clue").gen_clues.marks(),
      require("mini.clue").gen_clues.registers(),
      require("mini.clue").gen_clues.windows(),
      require("mini.clue").gen_clues.z(),
    },
    window = {
      delay = 300,
    },
  })
end)

later(function()
  require("mini.git").setup()
end)

later(function()
  require("mini.icons").setup()
end)

later(function()
  require("mini.indentscope").setup()
end)

later(function()
  require("mini.notify").setup()
  vim.notify = MiniNotify.make_notify()
end)

later(function()
  require("mini.pairs").setup()
end)

later(function()
  require("mini.pick").setup({
    mappings = {
      choose_in_vsplit = "<C-CR>",
    },
    options = {
      use_cache = true,
    },
  })
  vim.ui.select = MiniPick.ui_select
end)

now(function()
  Mvim_starter_custom = function()
    return {
      { name = "Recent Files", action = function() require("mini.extra").pickers.oldfiles() end, section = "Search" },
      { name = "Session",      action = function() require("mini.sessions").select() end,        section = "Search" },
    }
  end
  require("mini.starter").setup({
    autoopen = true,
    items = {
      -- require("mini.starter").sections.builtin_actions(),
      Mvim_starter_custom(),
      require("mini.starter").sections.recent_files(5, false, false),
      require("mini.starter").sections.recent_files(5, true, false),
      require("mini.starter").sections.sessions(5, true),
    }
  })
end)

later(function()
  require("mini.statusline").setup()
end)

later(function()
  require("mini.surround").setup()
end)

require("settings")
require("mappings")
require("autocmd")


-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
--   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
--   if vim.v.shell_error ~= 0 then
--     vim.api.nvim_echo({
--       { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
  --       { out,                            "WarningMsg" },
  --       { "\nPress any key to exit..." },
  --     }, true, {})
  --     vim.fn.getchar()
  --     os.exit(1)
  --   end
  -- end
  -- vim.opt.rtp:prepend(lazypath)
  --
  -- require("lazy").setup("plugins")
