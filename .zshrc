# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Aliases
alias battery_health="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias battery_stats="sudo tlp-stat -b"
alias cleanp="rm -r node_modules; rm package-lock.json; npm i"
alias ddp="npm dedupe && npm prune"
alias flushdns="sudo systemd-resolve --flush-caches"
alias gilelundro="sapu"
alias home="cd ~"
alias jsf="npm run format; npm run lint; npm run type-check"
alias kocheng="cat"
alias kochenk="cat"
alias l="lc"
alias lc="colorls -lA --sd"
alias lll="colorls"
alias llll="colorls -al"
alias nrb="npm run build"
alias nrd="npm run dev"
alias nrf="npm run format"
alias profile="vim ~/.zshrc"
alias sapu="pint; jsf"
alias server1="python3 -m http.server 8001;"
alias server2="python3 -m http.server 8002;"
alias v="nvim"
alias ww="cd ~/webserver"
alias www="cd ~/webserver/www/"
alias yrd="yarn run dev"
alias yrp="yarn run production"
alias yrw="yarn run watch"

# PHP
phpserver () {
  if [ ! -z $1 ]; then
    php -S localhost:800$1
  else
    php -S localhost:8000
  fi
}
alias sv=phpserver
alias pint="vendor/bin/pint"
alias t="vendor/bin/phpunit"
alias tcov="php artisan test --coverage"
alias tf="vendor/bin/phpunit --filter"
alias tg="vendor/bin/phpunit --group"

# Laravel
alias mig="pa migrate"
alias miro="pa migrate:rollback"
alias p="vendor/bin/pest"
alias pa="php artisan"
alias pf="vendor/bin/pest --filter"
alias pg="vendor/bin/pest --group"
alias php74="sudo update-alternatives --set php /usr/bin/php7.4; sudo systemctl stop php8.1-fpm.service; sudo systemctl stop php8.0-fpm.service; sudo systemctl start php7.4-fpm.service;"
alias php80="sudo update-alternatives --set php /usr/bin/php8.0; sudo systemctl stop php8.1-fpm.service; sudo systemctl stop php7.4-fpm.service; sudo systemctl start php8.0-fpm.service;"
alias php81="sudo update-alternatives --set php /usr/bin/php8.1; sudo systemctl stop php8.0-fpm.service; sudo systemctl stop php7.4-fpm.service; sudo systemctl start php8.1-fpm.service;"
alias seed="pa db:seed"
alias setup="sh /Users/harry/Tools/laravel-project-config/run.sh"
alias tink="pa tinker"
alias vendro="vendor/bin/pint && vendor/bin/pest"

# Symfony
alias sc="php bin/console"

# Git
alias gcm="git commit -m"
alias ggpp="git up; ggpush"
alias merge="g co master; g merge develop; g co develop; g push --all"
alias nah="git reset --hard;git clean -df"
alias wip="git add . && git commit -m 'wip'"

# Python and Django
alias dje="source ~/.virtualenvs/djangoenv/bin/activate"
alias p3="python3"
alias pm="python3 manage.py"

# Rails
alias r="rails"

# Node.js
alias sq="npx sequelize"

# System utilities
alias clearswap="sudo swapoff -a && sudo swapon -a"

# Hyprland
alias waybar_reload="pkill waybar && hyprctl dispatch exec waybar"

# Neovim
alias nvim-switch="$HOME/nvim-switch.sh"

DEFAULT_USER="harry"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Update frequency for oh-my-zsh
export UPDATE_ZSH_DAYS=1

# Plugins
plugins=(git composer git-flow)

source $ZSH/oh-my-zsh.sh

# PATH customizations
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
PATH=$PATH:$HOME/.config/composer/vendor/bin
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:/usr/local/go/bin
PATH=$PATH:/Users/harry/Library/Python/3.7/bin
PATH=$PATH:/home/harry/.local/bin
PATH=$PATH:$HOME/.rbenv/bin:$PATH
PATH=$PATH:/home/harry/Application/PhpStorm-221.5921.28/bin
PATH=$PATH:/home/harry/.cargo/bin/

. ~/z.sh

# OS-specific zsh plugins
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    arch)
      source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
      ;;
    ubuntu)
      source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      ;;
    pop)
      source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      ;;
  esac
fi

# Additional environment variables
export ANDROID_HOME=$HOME/Android/Sdk
export GOPATH=$HOME/.go
export LANG="$LC_ALL"
export LC_ALL=en_US.UTF-8
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$GOPATH/bin

export HOMEBREW_GITHUB_API_TOKEN=2db8242ae3110d4b4d2ace9df6e8c6f1c1a186a8

# Tmux 256-color
[[ -n $TMUX ]] && export TERM="screen-256color"

# Function paths
fpath+=${ZDOTDIR:-~}/.zsh_functions

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

