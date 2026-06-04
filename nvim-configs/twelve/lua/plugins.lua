local function use(name, repo, opts)
  opts = opts or {}
  opts.name = name
  opts.repo = repo
  return opts
end

local module_names = {
  "colors",
  "core",
  "comment",
  "conform",
  "csv",
  "emmet",
  "fzf-lua",
  "git",
  "grug-far",
  "linter",
  "cmp",
  "lsp",
  "markdown",
  "mini",
  "neotest",
  "oil",
  "text-case",
  "wakatime",
  "which-key",
  "todo",
  "treesitter",
}

local specs = {}
for _, name in ipairs(module_names) do
  local ok, module = pcall(require, "plugins." .. name)
  if ok and type(module) == "table" then
    if module[1] then
      for _, spec in ipairs(module) do
        specs[#specs + 1] = spec
      end
    else
      specs[#specs + 1] = module
    end
  end
end

return specs
