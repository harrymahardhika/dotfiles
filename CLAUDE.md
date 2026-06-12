# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Symlink Management

This repo is managed with **GNU Stow**. Running `stow .` from `~/dotfiles` creates symlinks in `~/` mirroring the repo structure. `.stow-local-ignore` excludes `.antidote` and `.git` from being stowed.

```bash
stow .          # apply all symlinks
stow -D .       # remove all symlinks
stow -R .       # restow (remove then re-apply)
```

After editing any config file, changes are live immediately since `~/.config/foo` is already a symlink into this repo — no re-stow required.

## ZSH Loading Order

`.zshrc` loads in this order:
1. Oh-My-Zsh (git plugin only; theme disabled)
2. Antidote plugins from `.zsh_plugins.txt` (syntax-highlighting excluded here, loaded last)
3. All `~/.zsh/*.zsh` modules (alphabetical: aliases, config, exports, functions, history, prompt)
4. FZF key bindings (loaded last to keep `Ctrl+R` bound)

To add a ZSH plugin: append to `.zsh_plugins.txt`, then run `scripts/antidote-bootstrap.sh`.

To reload ZSH config in the current shell: `reload` (alias for `source ~/.zshrc`).

## Neovim Configs

Four configs live under `nvim-configs/`: `beta`, `harry`, `custom-nvchad`, `twelve`. The active one is a symlink at `~/.config/nvim`.

```bash
nvim-switch      # interactive picker (alias for scripts/nvim-switch.sh)
```

`nvim-configs/stylua.toml` is the shared Lua formatter config. `lazy-lock.json` files are gitignored per config.

## Key Scripts

- `updateall` — full system update (pacman/apt + AUR + flatpak + snap + composer + npm/pnpm + uv). Run as non-root; handles sudo internally.
- `scripts/nvim-switch.sh` — switches active Neovim config by re-symlinking `~/.config/nvim`
- `scripts/php-switch.sh` — switches active PHP version via `update-alternatives`
- `scripts/tmux-pick` — fzf-based tmux session picker (bound to `prefix+s` in tmux)
- `scripts/antidote-bootstrap.sh` — installs/updates Antidote and compiles the plugin bundle

## Theme

**Catppuccin Mocha** is used consistently across all tools. When adding or editing configs for new tools, use the Mocha palette. FZF colors in `.zsh/config.zsh` are the reference for hex values.

## Gitignore Notes

`nvim-configs/*/lazy-lock.json` and `*.log` are gitignored. `.config/btop/*.conf` is also excluded since btop overwrites it at runtime.
