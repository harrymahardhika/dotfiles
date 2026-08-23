# History settings
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS     # no duplicate entries
setopt HIST_REDUCE_BLANKS       # strip extra spaces
setopt HIST_IGNORE_SPACE        # don't save commands starting with space
setopt SHARE_HISTORY            # sync between terminals (implies INC_APPEND + APPEND)
setopt EXTENDED_HISTORY         # timestamps

