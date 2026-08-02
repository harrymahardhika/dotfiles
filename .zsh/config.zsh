# Bindkeys
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line

# Better directory navigation
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Make cd push old directory onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print directory stack

# Completion improvements
setopt COMPLETE_IN_WORD     # Complete from both ends
setopt ALWAYS_TO_END        # Move cursor to end after completion
setopt AUTO_MENU            # Show completion menu on tab
setopt AUTO_LIST            # Automatically list choices
setopt MENU_COMPLETE        # Insert first match immediately

# Globbing improvements
setopt EXTENDED_GLOB        # Use extended globbing
setopt GLOB_DOTS            # Include dotfiles in glob

# FZF initialization
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [[ -f ~/.fzf/shell/completion.zsh ]]; then
  source ~/.fzf/shell/completion.zsh
fi

export FZF_DEFAULT_OPTS=" \
--color=bg+:#16161d,bg:#1f1f28,spinner:#dcd7ba,hl:#e46876 \
--color=fg:#dcd7ba,header:#e46876,info:#957fb8,pointer:#dcd7ba \
--color=marker:#8992b2,fg+:#dcd7ba,prompt:#957fb8,hl+:#e46876 \
--color=selected-bg:#2a2a37 \
--color=border:#16161d,label:#dcd7ba"
