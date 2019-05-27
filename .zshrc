# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="harry-chevron"
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="agnoster"
# ZSH_THEME="ys"

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

alias server1="python3 -m http.server 8001;"
alias server2="python3 -m http.server 8002;"
alias flushdns="sudo killall -HUP mDNSResponder"
alias ddp="npm dedupe && npm prune"
alias yrd="yarn run dev"
alias yrp="yarn run production"
alias yrw="yarn run watch"

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
alias t="vendor/bin/phpunit"

# laravel
pas () {
    if [ ! -z $1 ]
    then
        php artisan serve --port=800$1
    else
        php artisan serve
    fi
}
alias pas=pas
alias pa="php artisan"
alias mig="pa migrate"
alias miro="pa migrate:rollback"
alias seed="pa d:s"
alias tink="pa tinker"

# symfony
alias sc="php bin/console"

# git
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
# COMPLETION_WAITING_DOTS="true"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

plugins=(git composer ruby zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

PATH=$PATH:$HOME/.config/composer/vendor/bin
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:/usr/local/opt/go/libexec/bin
PATH=$PATH:/Users/harry/Library/Python/3.7/bin
PATH=$PATH:$HOME/.rbenv/bin:$PATH

eval "$(rbenv init -)"

. ~/z.sh
#. ~/.sshaliasesrc

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme

export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"

# go
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# android studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# powerlevel9k
POWERLEVEL9K_MODE=nerdfont-complete
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs laravel_version rbenv virtualenv)
POWERLEVEL9K_DISABLE_RPROMPT=true
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time battery)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"

export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"
export HOMEBREW_GITHUB_API_TOKEN=a40c656fe1331a1de234febf27b8e80be604e8c1
