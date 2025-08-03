# Laravel
alias pa="php artisan"
alias p="vendor/bin/pest"
alias pcov="vendor/bin/pest --coverage"
alias pint="vendor/bin/pint"
alias seed="pa db:seed"
alias tink="pa tinker"
alias rl="php artisan route:list"
alias pstan="vendor/bin/phpstan analyse"
alias rekt="vendor/bin/rector"

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
alias clear_swap="sudo swapoff -a && sudo swapon -a"
alias home="cd ~"

# Custom scripts
alias change-wallpaper="$HOME/scripts/set-wallpaper.sh"
alias nvim-switch="$HOME/scripts/nvim-switch.sh"
alias php-switch="$HOME/scripts/php-switch.sh"
alias updateall="$HOME/updateall"
alias changelog="$HOME/scripts/changelog.sh"
alias battery_limit="$HOME/scripts/battery_limit.sh"

# Git
alias gcm="git commit -m"
alias wip="git add . && git commit -m 'wip'"
alias nah="git reset --hard; git clean -df"

# Python/Django
alias dje="source ~/.virtualenvs/djangoenv/bin/activate"
alias p3="python3"
alias pm="python3 manage.py"

