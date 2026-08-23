# Set default user for prompt shortening
export DEFAULT_USER="harry"

# oh-my-zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode disabled
plugins=(git)
# Shadow compinit while OMZ loads so its completion lib skips its own full
# (slow) scan — exactly one cached compinit runs below.
compinit() { :; }
source $ZSH/oh-my-zsh.sh
unfunction compinit

# Load Antidote and plugins
if [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"
  antidote load < <(grep -v '^zsh-users/zsh-syntax-highlighting$' "$HOME/.zsh_plugins.txt")
else
  print -u2 "antidote: missing $HOME/.antidote/antidote.zsh; run scripts/antidote-bootstrap.sh"
fi

# Initialize completion
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"
autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

# Load custom configuration (before syntax highlighting per AGENTS.md order)
for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

# Load syntax highlighting last among plugins so it can hook the final widget state.
if [[ -r "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]]; then
  source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi

# Load FZF key bindings last so reverse search stays bound.
if [[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
  source "$HOME/.fzf/shell/key-bindings.zsh"
elif [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi


# Added by Antigravity CLI installer (made portable; deduped by typeset -U in exports.zsh)
export PATH="$HOME/.local/bin:$PATH"
