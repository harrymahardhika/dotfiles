# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="agnoster"
ZSH_THEME="robbyrussell"
# ZSH_THEME="avit-custom"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias mtr="mtr -t"
alias ww="cd ~/webserver"
alias www="cd ~/webserver/www/"
alias code="cd ~/Code/"
alias profile="vim ~/.zshrc"
alias l="ls -alh"
alias home="cd ~"

alias server1="python3 -m http.server 8001;"
alias server2="python3 -m http.server 8002;"

alias flushdns="sudo killall -HUP mDNSResponder"

alias ddp="npm dedupe && npm prune"

alias mgit="/usr/local/bin/git"

# php
alias pa="php artisan"

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

alias homestead='function __homestead() { (cd ~/Homestead && vagrant $*); unset -f __homestead; }; __homestead'

DEFAULT_USER="harry"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=1

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-flow osx brew z)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
#export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/

export PATH=$PATH:/Users/harry/phalcon-tools
export PTOOLSPATH=/Users/harry/phalcon-tools

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/.composer/vendor/bin

PERL_MB_OPT="--install_base \"/Users/harry/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/harry/perl5"; export PERL_MM_OPT;
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

. ~/z.sh

