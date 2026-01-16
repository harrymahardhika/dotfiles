# Dotfiles

Personal configuration files for Linux development environment with support for both X11 and Wayland.

## Features

- **Multiple Neovim Configurations** - Four separate configs (beta, harry, astro, nvchad) with easy switching
- **Modular Shell Setup** - Clean, organized ZSH configuration with Antidote plugin manager
- **Cross-Environment Support** - Configs for both X11 (i3) and Wayland (Hyprland, Sway)
- **PHP/Laravel Focus** - Extensive tooling for PHP development with version switching
- **Unified Theme** - Catppuccin Mocha color scheme across all applications
- **Automation Scripts** - System updates, web app launchers, and utility scripts

## Structure

```
dotfiles/
├── .config/              # XDG-compliant application configs
│   ├── alacritty/       # Terminal emulator
│   ├── hypr/            # Hyprland (Wayland WM)
│   ├── i3/              # i3wm (X11 WM)
│   ├── kitty/           # Kitty terminal
│   ├── lazygit/         # Git TUI
│   ├── rofi/            # App launcher (X11)
│   ├── sway/            # Sway (Wayland WM)
│   ├── tmux/            # Tmux config
│   ├── waybar/          # Status bar (Wayland)
│   ├── yazi/            # File manager TUI
│   └── ...              # 30+ other configs
├── nvim-configs/        # Multiple Neovim setups
│   ├── beta/           # Beta/testing config
│   ├── harry/          # Personal config
│   ├── astro/          # AstroNvim-based
│   └── nvchad/         # NvChad-based
├── scripts/             # Utility scripts
│   ├── webapps/        # Web app launchers
│   ├── nvim-switch.sh  # Switch Neovim configs
│   ├── php-switch.sh   # PHP version manager
│   └── ...             # Additional utilities
├── .zsh/                # Modular ZSH config
│   ├── aliases.zsh     # Command aliases
│   ├── exports.zsh     # Environment variables
│   ├── functions.zsh   # Shell functions
│   └── ...             # Other modules
├── .zshrc               # Main ZSH entry point
├── .tmux.conf           # Tmux configuration
├── .gitconfig           # Git settings
└── wallpapers/          # Desktop wallpapers
```

## Key Components

### Shell (ZSH)

- **Plugin Manager**: Antidote for fast plugin loading
- **Plugins**: fzf, zoxide, autosuggestions, syntax-highlighting, wakatime
- **Prompt**: Starship with Catppuccin theme
- **Features**: 
  - Laravel/PHP development aliases
  - Git shortcuts
  - Node.js/pnpm helpers
  - Custom functions and utilities

### Neovim

Four separate configurations available via `nvim-switch.sh`:

- **beta** - Testing ground for new plugins/features, using blink.cmp
- **harry** - Personal stable configuration
- **astro** - AstroNvim community distribution
- **nvchad** - NvChad community distribution

All configs use Lazy.nvim plugin manager.

### Tmux

- Custom prefix: `Ctrl+a`
- Vim-style navigation
- Catppuccin Mocha theme
- Session persistence (tmux-resurrect, tmux-continuum)
- Gitmux integration for git status
- Custom popup session switcher

### Window Managers

#### Wayland
- **Hyprland** - Primary Wayland compositor
- **Sway** - Alternative i3-like compositor

#### X11
- **i3wm** - Tiling window manager

All with corresponding status bars (waybar/polybar), launchers (wofi/rofi), and compositors.

### Terminal Emulators

Multiple options configured with Catppuccin theme:
- Kitty (primary)
- Alacritty
- Ghostty
- Foot
- WezTerm

### Development Tools

#### PHP/Laravel
- PHP version switcher (8.2, 8.3, 8.4)
- Laravel artisan aliases
- Pest, PHPStan, Rector, Pint shortcuts
- Nginx config templates

#### Version Control
- Git with Delta pager
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

- **`updateall`** - Update all packages (pacman, yay, flatpak, snap, composer, npm, pnpm, uv)
- **`nvim-switch.sh`** - Switch between Neovim configurations
- **`php-switch.sh`** - Change PHP version system-wide

### Web Apps

Launch web applications as desktop apps via `scripts/webapps/`:
- ChatGPT, Claude, Gemini
- GitHub, Gmail, Google Drive
- Notion, Spotify, WhatsApp
- YouTube, and more

### Utilities

- `tmux-pick` - Interactive tmux session picker
- `set-wallpaper.sh` - Wallpaper setter
- `battery_limit.sh` - Battery charge limiting
- `waybar-cleanup.sh` - Clean up waybar processes

## Technology Stack

**Languages**: PHP (8.2-8.4), Node.js, Python, Go, Rust  
**Shells**: ZSH (primary), Fish  
**Editors**: Neovim, Helix, Zed  
**Terminals**: Kitty, Alacritty, Ghostty, Foot, WezTerm  
**WM**: Hyprland, Sway, i3wm  
**Theme**: Catppuccin Mocha (consistent across all tools)

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

**Note**: GNU Stow will create symlinks from `~/dotfiles/*` to `~/*`. Ensure no conflicting files exist in your home directory before stowing.

### ZSH Setup

```bash
# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Antidote plugin manager
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
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
./scripts/nvim-switch.sh beta

# Install plugins (inside Neovim)
# Lazy.nvim will auto-install on first launch
```

## Customization

- **Colors**: Edit theme files in respective config directories
- **Keybindings**: Check `.config/hypr/`, `.config/i3/`, `.tmux.conf`
- **Aliases**: Modify `.zsh/aliases.zsh`
- **Plugins**: Edit `.zsh_plugins.txt` for ZSH, `lua/plugins/` for Neovim

## Dependencies

Core tools required:

```bash
# Arch Linux
yay -S zsh tmux neovim kitty alacritty \
  hyprland sway i3-wm waybar rofi wofi \
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

This is a personal configuration optimized for PHP/Laravel development with support for multiple environments. Feel free to use as inspiration or reference for your own dotfiles.
