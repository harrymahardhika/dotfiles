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
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"
