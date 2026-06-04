local M = {}

function M.use(name, repo, opts)
  opts = opts or {}
  opts.name = name
  opts.repo = repo
  return opts
end

return M
