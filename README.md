# Dotfiles

Personal configuration files for Linux development environment with support for
both X11 and Wayland.

## Features

- **Multiple Neovim Configurations** - Two configs (twelve, twenty-six) with easy switching
- **Modular Shell Setup** - Clean, organized ZSH configuration with Antidote
  plugin manager
- **Cross-Environment Support** - Configs for both X11 (i3) and Wayland
  (Hyprland, Sway)
- **PHP/Laravel Focus** - Extensive tooling for PHP development with version
  switching
- **Theme Switching** - Swaps the whole system between mocha, kanagawa,
  tokyonight, rosepine, and gruvbox (mocha default)
- **Automation Scripts** - System updates, web app launchers, and utility
  scripts

## Structure

```
dotfiles/
├── .config/             # XDG-compliant application configs
│   ├── alacritty/       # Terminal emulator
│   ├── hypr/            # Hyprland (Wayland WM)
│   ├── i3/              # i3wm (X11 WM)
│   ├── kitty/           # Kitty terminal
│   ├── lazygit/         # Git TUI
│   ├── rofi/            # App launcher (X11)
│   ├── sway/            # Sway (Wayland WM)
│   ├── waybar/          # Status bar (Wayland)
│   ├── yazi/            # File manager TUI
│   └── ...              # 30+ other configs
├── nvim-configs/        # Multiple Neovim setups
│   ├── twelve/          # Native-package config
│   ├── twenty-six/      # Lazy.nvim config
│   └── stylua.toml      # Lua formatting config
├── scripts/             # Utility scripts
│   ├── webapps/         # Web app launchers
│   ├── nvim-switch.sh   # Switch Neovim configs
│   ├── php-switch.sh    # PHP version manager
│   └── ...              # Additional utilities
├── .zsh/                # Modular ZSH config
│   ├── aliases.zsh      # Command aliases
│   ├── exports.zsh      # Environment variables
│   ├── functions.zsh    # Shell functions
│   └── ...              # Other modules
├── .zshrc               # Main ZSH entry point
├── .tmux.conf           # Tmux configuration
├── .gitconfig           # Git settings
└── wallpapers/          # Desktop wallpapers
```

## Key Components

### Shell (ZSH)

- **Plugin Manager**: Antidote for fast plugin loading
- **Plugins**: fzf, zoxide, autosuggestions, syntax-highlighting, wakatime
- **Prompt**: Starship with the active theme
- **Features**:
  - Laravel/PHP development aliases
  - Git shortcuts
  - Node.js/pnpm helpers
  - Custom functions and utilities

### Neovim

Two configurations available via `nvim-switch.sh`:

- **twelve** - Native-package Neovim config (uses native packages, zero external plugin managers)
- **twenty-six** - Lazy.nvim-based config

Most configs use the Lazy.nvim plugin manager, while `twelve` leverages native package loading.

### Tmux

- Custom prefix: `Ctrl+a`
- Vim-style navigation
- Active theme (mocha/kanagawa/tokyonight/rosepine/gruvbox via theme-switch)
- Session persistence (tmux-resurrect, tmux-continuum)
- Gitmux integration for git status
- Custom popup session switcher

### Window Managers

#### Wayland

- **Hyprland** - Primary Wayland compositor with scrolling layout enabled and
  systemd integration
- **Waybar** - Prefer `waybar-git` on Hyprland so workspace clicks keep working
- **Sway** - Alternative i3-like compositor

#### X11

- **i3wm** - Tiling window manager

All with corresponding status bars (waybar/polybar), launchers (wofi/rofi), and
compositors.

### Terminal Emulators

Multiple options, all following the active theme:

- Kitty (primary)
- Alacritty
- Ghostty
- Foot
- WezTerm

### Development Tools

#### PHP/Laravel

- PHP version switcher (8.3, 8.4)
- Laravel artisan aliases
- Pest, PHPStan, Rector, Pint shortcuts
- Nginx config templates

#### Version Control

- Git with custom aliases and sane defaults
- Lazygit TUI
- Custom git aliases

#### Other Tools

- Helix, Zed editors
- Yazi file manager
- btop system monitor
- bat (better cat)
- glow (markdown renderer)

## Scripts

### System Management

- **`updateall`** - Robust multi-OS (Arch, Ubuntu/Debian) update script for all
  packages (pacman, paru/yay, flatpak, snap, composer, npm, pnpm, uv). Features
  sudo preflight, error handling (continues on tool failure), and OS-specific
  summary.
- **`nvim-switch.sh`** - Switch between Neovim configurations
- **`php-switch.sh`** - Switch PHP tool versions via user-level shims (`~/.local/bin/php`, `pecl`, …); Ubuntu variant uses `update-alternatives`

### Web Apps

Launch web applications as desktop apps via `scripts/webapps/`:

- ChatGPT, Claude, Gemini
- GitHub, Gmail, Google Drive
- Notion, Spotify, WhatsApp
- YouTube, and more

### Utilities

- `scripts/tmux/tmux-pick.sh` - Interactive tmux session picker
- `set-wallpaper.sh` - Wallpaper setter
- `battery_limit.sh` - Battery charge limiting
- `waybar-cleanup.sh` - Clean up waybar processes

## Technology Stack

**Languages**: PHP (8.3-8.4), Node.js, Python, Go, Rust **Shells**: ZSH
(primary), Fish **Editors**: Neovim, Helix, Zed **Terminals**: Kitty, Alacritty,
Ghostty, Foot, WezTerm **WM**: Hyprland, Sway, i3wm **Theme**: mocha
(default), kanagawa, tokyonight, rosepine, gruvbox (switched via `theme-switch`)

## Installation

This repository uses GNU Stow for managing symlinks.

### Prerequisites

```bash
# Arch Linux
sudo pacman -S stow

# Ubuntu/Debian
sudo apt install stow
```

### Setup

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow everything
stow .

# Or stow specific configs only
stow -d . -t ~ .config
stow -d . -t ~ .zsh .zshrc
stow -d . -t ~ .tmux.conf .gitconfig

# Unstow if needed
stow -D .
```

**Note**: GNU Stow will create symlinks from `~/dotfiles/*` to `~/*`. Ensure no
conflicting files exist in your home directory before stowing.

### Expected Home Symlinks

Two references live outside the stowed tree and need manual symlinks:

```bash
ln -s dotfiles/scripts ~/scripts             # required by .tmux.conf popups/status
ln -s dotfiles/nvim-configs ~/nvim-configs   # optional; nvim-switch falls back to ~/dotfiles/nvim-configs
```

### ZSH Setup

```bash
# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install or update Antidote and bundles
./scripts/antidote-bootstrap.sh
```

### Tmux Setup

```bash
# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins (inside tmux)
# Press: Ctrl+a + I
```

### Neovim Setup

```bash
# Switch to desired config
./scripts/nvim-switch.sh twenty-six

# Install plugins (inside Neovim)
# Lazy.nvim will auto-install on first launch
```

## Customization

- **Colors**: Use `theme-switch` to change themes; edit palettes in `themes/palettes/` and mocha masters in `themes/mocha/inline/`, then run `theme-switch sync-masters`
- **Keybindings**: Check `.config/hypr/`, `.config/i3/`, `.tmux.conf`
- **Aliases**: Modify `.zsh/aliases.zsh`
- **Plugins**: Edit `.zsh_plugins.txt` for ZSH, `lua/plugins/` for Neovim

## Dependencies

Core tools required:

```bash
# Arch Linux
yay -S zsh tmux neovim kitty alacritty \
  hyprland sway i3-wm waybar-git rofi wofi \
  starship zoxide fzf bat ripgrep fd \
  lazygit yazi btop php composer \
  nodejs npm pnpm

# Ubuntu/Debian
apt install zsh tmux neovim kitty \
  i3 rofi fzf ripgrep fd-find \
  php composer nodejs npm
```

## License

MIT

## Notes

This is a personal configuration optimized for PHP/Laravel development with
support for multiple environments. Feel free to use as inspiration or reference
for your own dotfiles.

Waybar on Hyprland works best with `waybar-git` here because newer Hyprland
workspace behavior is not handled correctly by older stable Waybar builds.
