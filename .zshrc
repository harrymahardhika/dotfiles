# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias mtr="mtr -t"
alias ww="cd ~/webserver"
alias www="cd ~/webserver/www/"
alias profile="vim ~/.zshrc"
alias l="lc"
alias home="cd ~"
alias lll="colorls"
alias llll="colorls -al"
alias lc="colorls -lA --sd"
alias kocheng="cat"
alias kochenk="cat"
alias v="nvim"

alias server1="python3 -m http.server 8001;"
alias server2="python3 -m http.server 8002;"
alias flushdns="sudo systemd-resolve --flush-caches"
alias ddp="npm dedupe && npm prune"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrf="npm run format"
alias yrd="yarn run dev"
alias yrp="yarn run production"
alias yrw="yarn run watch"
alias battery_stats="sudo tlp-stat -b"
alias battery_health="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias sapu="pint; jsf"
alias gilelundro="sapu"
alias jsf="npm run format; npm run lint; npm run type-check"
alias cleanp="rm -r node_modules; rm package-lock.json; npm i"

# php
phpserver () {
    if [ ! -z $1 ]
    then
        php -S localhost:800$1
    else
        php -S localhost:8000
    fi
}
alias sv=phpserver
alias pint="vendor/bin/pint"
alias t="vendor/bin/phpunit"
alias tf="vendor/bin/phpunit --filter"
alias tg="vendor/bin/phpunit --group"
alias tcov="php artisan test --coverage"

# laravel
alias pa="php artisan"
alias mig="pa migrate"
alias miro="pa migrate:rollback"
alias seed="pa db:seed"
alias tink="pa tinker"
alias p="vendor/bin/pest"
alias pf="vendor/bin/pest --filter"
alias pg="vendor/bin/pest --group"
alias setup="sh /Users/harry/Tools/laravel-project-config/run.sh"
alias php74="sudo update-alternatives --set php /usr/bin/php7.4; sudo systemctl stop php8.1-fpm.service; sudo systemctl stop php8.0-fpm.service; sudo systemctl start php7.4-fpm.service;"
alias php80="sudo update-alternatives --set php /usr/bin/php8.0; sudo systemctl stop php8.1-fpm.service; sudo systemctl stop php7.4-fpm.service; sudo systemctl start php8.0-fpm.service;"
alias php81="sudo update-alternatives --set php /usr/bin/php8.1; sudo systemctl stop php8.0-fpm.service; sudo systemctl stop php7.4-fpm.service; sudo systemctl start php8.1-fpm.service;"
alias vendro="vendor/bin/pint && vendor/bin/pest"

# symfony
alias sc="php bin/console"

# git
alias gcm="git commint -m"
alias wip="git add . && git commit -m 'wip'"
alias nah="git reset --hard;git clean -df"
alias ggpp="git up; ggpush"
alias merge="g co master; g merge develop; g co develop; g push --all"

# python and django
alias p3="python3"
alias pm="python3 manage.py"
alias dje="source ~/.virtualenvs/djangoenv/bin/activate"

# rails
alias r="rails"

# nodejs
alias sq="npx sequelize"

alias clearswap="sudo swapoff -a && sudo swapon -a"

# hyprland
alias waybar_reload="pkill waybar && hyprctl dispatch exec waybar"


DEFAULT_USER="harry"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=1

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

plugins=(git composer git-flow)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

PATH=$PATH:$HOME/.config/composer/vendor/bin
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:/usr/local/go/bin
PATH=$PATH:/Users/harry/Library/Python/3.7/bin
PATH=$PATH:/home/harry/.local/bin
PATH=$PATH:$HOME/.rbenv/bin:$PATH
PATH=$PATH:/home/harry/Application/PhpStorm-221.5921.28/bin
PATH=$PATH:/home/harry/.cargo/bin/

# eval "$(rbenv init -)"

. ~/z.sh

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

export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# go
# export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# android studio
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export LC_ALL=en_US.UTF-8
export LANG="$LC_ALL"

export HOMEBREW_GITHUB_API_TOKEN=2db8242ae3110d4b4d2ace9df6e8c6f1c1a186a8

# tmux 256-color
[[ -n $TMUX ]] && export TERM="screen-256color"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fpath+=${ZDOTDIR:-~}/.zsh_functions

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
