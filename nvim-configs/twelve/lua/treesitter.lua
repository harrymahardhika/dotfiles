local api = vim.api

local group = api.nvim_create_augroup("TwelveTreesitter", { clear = true })

local function should_disable(buf)
  local max_filesize = 100 * 1024
  local ok, stats = pcall(vim.uv.fs_stat, api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > max_filesize or false
end

local function start_treesitter(buf)
  if not api.nvim_buf_is_valid(buf) then
    return
  end

  local ft = vim.bo[buf].filetype
  if not ft or ft == "" or should_disable(buf) then
    return
  end

  local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
  lang = (ok and lang) or ft
  if not lang or lang == "" then
    return
  end

  local ok_start = pcall(vim.treesitter.start, buf, lang)
  if ok_start then
    pcall(api.nvim_set_option_value, "syntax", "off", { buf = buf })
  end
end

api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
  group = group,
  callback = function(args)
    start_treesitter(args.buf)
  end,
})

vim.opt.foldmethod = "expr"
if vim.treesitter and vim.treesitter.foldexpr then
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
else
  vim.opt.foldexpr = "0"
end
vim.opt.foldenable = true
