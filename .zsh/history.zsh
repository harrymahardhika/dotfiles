# History settings
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS     # no duplicate entries
setopt HIST_REDUCE_BLANKS       # strip extra spaces
setopt HIST_IGNORE_SPACE        # don't save commands starting with space
setopt INC_APPEND_HISTORY       # write after each command
setopt SHARE_HISTORY            # sync between terminals
setopt APPEND_HISTORY           # avoid overwrite
setopt EXTENDED_HISTORY         # timestamps

