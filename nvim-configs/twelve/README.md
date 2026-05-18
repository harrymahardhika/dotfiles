# twelve

Native-package Neovim config inspired by `nvim-configs/beta`.

## Notes

- Plugins are declared in `lua/twelve/plugins.lua`.
- Bootstrapping and lazy loading are handled by `lua/twelve/pack.lua`.
- Plugin clones are stored in Neovim's data directory under `site/pack/twelve`.
- This config does not use the `nvim-treesitter` plugin manager layer.
- Installed Tree-sitter parsers are still started through Neovim core in `lua/twelve/treesitter.lua`.
- If `~/.local/share/nvim/lazy/nvim-treesitter/runtime` exists, `twelve` reuses its query files for languages like `php`, `typescript`, and `vue`.

## Commands

- `:PackInstall`
- `:PackUpdate`
- `:PackClean`
- `:PackSync`
- `:PackStatus`
- `:PackProfile`

## Startup Performance

- `:PackProfile` shows setup phases and per-plugin load/config times inside Neovim.
- `nvim --startuptime /tmp/nvim-startup.log` gives the full native Neovim startup trace if you want lower-level detail.
