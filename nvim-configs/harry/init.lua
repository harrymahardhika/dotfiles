require("settings")
require("mappings")
require("harry.autocmd")
require("harry.lazy")

vim.api.nvim_create_user_command("BufOnly", function()
  vim.cmd('silent! %bd | e# | bd#')
end, {})
