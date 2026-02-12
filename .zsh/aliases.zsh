# General
alias cl="clear"

# Better defaults
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'

# Laravel
alias getrekt="vendor/bin/rector"
alias mig="pa migrate"
alias miro="pa migrate:rollback"
alias p="vendor/bin/pest"
alias pa="php artisan"
alias pc="vendor/bin/pest --coverage-html coverage-report"
alias pcov="vendor/bin/pest --coverage"
alias pcp="vendor/bin/pest --coverage-html coverage-report --parallel"
alias pf="vendor/bin/pest --filter"
alias pg="vendor/bin/pest --group"
alias pint="vendor/bin/pint"
alias pp="vendor/bin/pest --parallel"
alias pstan="vendor/bin/phpstan analyse"
alias rekt="vendor/bin/rector"
alias rl="php artisan route:list"
alias seed="pa db:seed"
alias tink="pa tinker"

# PHP switchers
alias php82="sudo update-alternatives --set php /usr/bin/php8.2"
alias php83="sudo update-alternatives --set php /usr/bin/php8.3"
alias php84="sudo update-alternatives --set php /usr/bin/php8.4"

# Node/NPM/Yarn
alias npmi="npm install"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrf="npm run format"
alias yrd="yarn run dev"
alias yrw="yarn run watch"
alias yrp="yarn run production"
alias jsf="npm run format && npm run lint && npm run type-check"
alias cleanp="rm -r node_modules; rm package-lock.json; npm i"
alias ddp="npm dedupe && npm prune"

# Utilities
alias profile="vim ~/.zshrc"
alias reload="source ~/.zshrc"
alias v="nvim"
alias y="yazi"
alias lg="lazygit"
alias hyprland="uwsm start hyprland.desktop"
alias clear_swap="sudo swapoff -a && sudo swapon -a"
alias home="cd ~"

# Custom scripts
alias change-wallpaper="$HOME/scripts/set-wallpaper.sh"
alias nvim-switch="$HOME/scripts/nvim-switch.sh"
alias nvim-cleanup="$HOME/scripts/nvim-cleanup.sh"
alias php-switch="$HOME/scripts/php-switch.sh"
alias updateall="$HOME/updateall"
alias changelog="$HOME/scripts/changelog.sh"
alias battery_limit="$HOME/scripts/battery_limit.sh"

# Git
alias gs='git status'
alias gd='git diff'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias ga='git add'
alias gcm="git commit -m"
alias gca='git commit --amend'
alias wip="git add . && git commit -m 'wip'"
alias nah="git reset --hard; git clean -df"
alias csd="gd --staged | xclip -sel clipboard"
alias gdsc="git diff --staged | wl-copy"

# Python/Django
alias dje="source ~/.virtualenvs/djangoenv/bin/activate"
alias python="python3"
alias p3="python3"
alias pm="python3 manage.py"

# Paru aliases
alias pru='paru -Syu'
alias pri='paru -S'
alias prs='paru -Ss'
alias prr='paru -Rns'

