# Set default user for prompt shortening
export DEFAULT_USER="harry"

# oh-my-zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode disabled
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Load Antidote and plugins
source $HOME/.antidote/antidote.zsh
antidote load < $HOME/.zsh_plugins.txt

# Defer compinit for faster startup
zsh-defer compinit -C

# Load custom configuration
for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

