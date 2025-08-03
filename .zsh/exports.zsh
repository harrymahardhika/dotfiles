# Editor and system prefs
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# Language/Locale
export LANG="$LC_ALL"
export LC_ALL="en_US.UTF-8"

# PATHs
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH=$PATH:$HOME/.config/composer/vendor/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.rbenv/bin
export PATH=$PATH:/usr/local/go/bin

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

# Golang
export GOPATH="$HOME/.go"
export PATH=$PATH:$GOPATH/bin

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# Terminal
export TERM="xterm-256color"

