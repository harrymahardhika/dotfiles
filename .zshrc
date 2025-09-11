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

# Async plugin loading (after prompt ready)
zsh-defer source "${ANTIDOTE_CACHE_DIR:-$HOME/.cache/antidote}"/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source "${ANTIDOTE_CACHE_DIR:-$HOME/.cache/antidote}"/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer compinit -C

# Load custom configuration
for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

