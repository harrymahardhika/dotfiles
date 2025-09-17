return {
  {
    "nvim-mini/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.splitjoin").setup()
      -- require("mini.statusline").setup()
      -- vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { bg = "NONE" })

      require("mini.surround").setup()
    end,
  },
}
