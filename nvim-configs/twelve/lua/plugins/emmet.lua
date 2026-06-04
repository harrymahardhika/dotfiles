local use = require("plugin-util").use

return use("emmet-vim", "mattn/emmet-vim", {
  pack = "opt",
  ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
  init = function()
    vim.g.user_emmet_leader_key = "<C-y>"
    vim.g.user_emmet_mode = "a"
    vim.g.user_emmet_settings = {
      vue = { extends = "html" },
      svelte = { extends = "html" },
      javascriptreact = { extends = "jsx" },
      typescriptreact = { extends = "jsx" },
    }
  end,
})
