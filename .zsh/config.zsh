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
  source ~/.fzf/shell/key-bindings.zsh
fi

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#313244,label:#CDD6F4"

