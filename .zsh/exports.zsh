# Editor and system prefs
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export XDG_CONFIG_HOME="$HOME/.config"

# Language/Locale
export LC_ALL="en_US.UTF-8"
export LANG="$LC_ALL"

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"

# Golang
export GOPATH="$HOME/.go"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"

# bun
export BUN_INSTALL="$HOME/.bun"

# PATHs - Build once for efficiency
typeset -U path  # Remove duplicates automatically
path=(
  $HOME/.opencode/bin
  $BUN_INSTALL/bin
  $PNPM_HOME
  $HOME/.cargo/bin
  $HOME/.composer/vendor/bin
  $HOME/.config/composer/vendor/bin
  $HOME/.local/bin
  $HOME/.rbenv/bin
  /usr/local/go/bin
  $GOPATH/bin
  $ANDROID_HOME/emulator
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/tools
  $ANDROID_HOME/tools/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  $path
)
export PATH

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

if [ -r "$HOME/.secrets" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.secrets"
fi
