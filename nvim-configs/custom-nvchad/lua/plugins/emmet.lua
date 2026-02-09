return {
  "mattn/emmet-vim",
  ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
  init = function()
    vim.g.user_emmet_leader_key = "<C-y>" -- default is <C-y>
    
    -- Enable Emmet in all modes for these filetypes
    vim.g.user_emmet_mode = "a" -- enable in all modes
    
    -- Configure Emmet for Vue files
    vim.g.user_emmet_settings = {
      vue = {
        extends = "html",
      },
      svelte = {
        extends = "html",
      },
      javascriptreact = {
        extends = "jsx",
      },
      typescriptreact = {
        extends = "jsx",
      },
    }
  end,
}
