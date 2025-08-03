# Set default user for prompt shortening
export DEFAULT_USER="harry"

# Load Antidote and plugins
source $HOME/.antidote/antidote.zsh
antidote load < $HOME/.zsh_plugins.txt

# Load custom configuration
for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

