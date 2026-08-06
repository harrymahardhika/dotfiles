# AGENTS.md

## Symlinks (GNU Stow)

`stow .` from `~/dotfiles` symlinks everything to `~`. `.stow-local-ignore` skips `.antidote` and `.git`. After editing a config, the change is live immediately — no re-stow needed.

## ZSH Loading Order

1. Oh-My-Zsh (git plugin only; **no theme**)
2. Antidote plugins from `.zsh_plugins.txt` (syntax-highlighting **excluded** here)
3. `~/.zsh/*.zsh` modules (alphabetical: aliases, config, exports, functions, history, prompt)
4. Syntax-highlighting sourced from `.cache/antidote/...` directly
5. FZF key bindings (last — keeps `Ctrl+R` bound)

New plugin: append to `.zsh_plugins.txt`, run `scripts/antidote-bootstrap.sh`. Reload: `reload`.

## Neovim

Two configs under `nvim-configs/`: `twelve`, `twenty-six`. Active one is a symlink at `~/.config/nvim`. Switch with `nvim-switch` (alias for `scripts/nvim-switch.sh`).

`nvim-configs/stylua.toml` is the shared Lua formatter config. `lazy-lock.json` files gitignored per config.

## Theme

**Catppuccin Mocha** everywhere. FZF colors in `.zsh/config.zsh` are the hex reference.

## Key Scripts

- `updateall` — full system update (pacman/apt + AUR + flatpak + snap + composer + npm/pnpm + uv). Run as non-root; sudo handled internally.
- `scripts/php-switch.sh` — PHP version via `update-alternatives` (8.2/8.3/8.4)
- `scripts/tmux/tmux-pick.sh` — fzf tmux session picker (bound to `prefix+s`)
- `scripts/nvim-switch.sh` — switches Neovim config symlink
- `scripts/trash-cleanup.sh` — removes FreeDesktop trash items older than 7 days. Runs daily via `trash-cleanup.timer` (systemd --user). Accepts `--dry-run`. Alias: `trash-cleanup`.

## Theme Switching

`scripts/theme-switch.sh` (alias `theme-switch`, rofi frontend `theme-pick`) swaps the whole system between **mocha** (default), **kanagawa**, **tokyonight**, and **rosepine**.

- Themes driven by `themes/palettes/<name>.palette` (semantic color map). Payload files live in `themes/<name>/`; inline (non-payload) configs are rendered from mocha masters under `themes/mocha/inline/`.
- After editing a config that's inlined (see `sync-masters`), run `theme-switch sync-masters` so masters stay authoritative — switching is then lossless in both directions.
- Run `theme-switch apply <name> --dry` to preview. `apply` reloads services (mako/waybar/dunst), hyprctl, and terminals (kitty SIGUSR1, ghostty SIGUSR2; alacritty live-reloads).
- `.config/opencode/tui.json` holds the opencode TUI theme (built-ins `catppuccin`/`kanagawa`/`tokyonight`/`rosepine`).
- Wallpapers live in `wallpapers/<theme>/` (mocha, kanagawa, tokyonight, rosepine). `theme-switch apply` randomizes a wallpaper from the active theme's subdir via `set-wallpaper.sh` (awww), which reads `~/.cache/theme-current` and falls back to `wallpapers/` root.
- tmux: catppuccin/tmux only ships catppuccin flavors, so non-mocha themes inject a `# THEME-SWITCH @thm_* OVERRIDES` block at the end of `.tmux.conf` (after the tpm `run`). The plugin uses `set -ogq`, so leftovers are unset before re-sourcing.
- Payload names are short (`mocha`, `kanagawa`, `tokyonight`, `rosepine`) — not `catppuccin-mocha`.

## Tmux

Prefix is `Ctrl+A` (not `Ctrl+B`). TPM plugins: clone `tmux-plugins/tpm` to `~/.tmux/plugins/tpm`, then `prefix+I` to install.

## Gitignore

`nvim-configs/*/lazy-lock.json`, `*.log`, `.config/btop/*.conf` (btop overwrites it at runtime).
