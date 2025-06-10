return {
  "mattn/emmet-vim",
  ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
  init = function()
    vim.g.user_emmet_leader_key = "<C-y>" -- default is <C-y>
  end,
}
