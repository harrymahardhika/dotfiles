# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="agnoster-custom"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="avit"
# ZSH_THEME="harry"
ZSH_THEME="harry-chevron"
# ZSH_THEME="dracula"
# ZSH_THEME="refined"
# ZSH_THEME="powerlevel9k/powerlevel9k"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias mtr="mtr -t"
alias ww="cd ~/webserver"
alias www="cd ~/webserver/www/"
alias profile="vim ~/.zshrc"
alias l="ls -alh"
alias home="cd ~"

alias server1="python3 -m http.server 8001;"
alias server2="python3 -m http.server 8002;"
alias flushdns="sudo killall -HUP mDNSResponder"
alias ddp="npm dedupe && npm prune"
alias ggpp="git up; ggpush"
alias yrd="yarn run dev"
alias yrp="yarn run production"
alias yrw="yarn run watch"
alias merge="g co master; g merge develop; g co develop; g push --all"

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

# symfony
alias sc="php bin/console"

# git
alias wip="git add . && git commit -m 'wip'"

alias t="vendor/bin/phpunit"

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

plugins=(git composer wakatime)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

PATH=$PATH:$HOME/.config/composer/vendor/bin
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:/usr/local/opt/go/libexec/bin

# PATH=$PATH:$HOME/.rbenv/bin:$PATH

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

. ~/z.sh
. ~/.sshaliasesrc

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"
