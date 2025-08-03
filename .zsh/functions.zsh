# Git prompt cache variable
GIT_PROMPT_CACHE=""

update_git_prompt_info() {
  GIT_PROMPT_CACHE=""
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local ref dirty ahead=0 behind=0

  ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return

  git diff --quiet 2>/dev/null || dirty="*"
  git diff --cached --quiet 2>/dev/null || dirty="$dirty+"

  if git rev-parse --abbrev-ref @{upstream} &>/dev/null; then
    local remote_status
    remote_status=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    behind=$(echo $remote_status | awk '{print ($1 ~ /^[0-9]+$/) ? $1 : 0}')
    ahead=$(echo $remote_status | awk '{print ($2 ~ /^[0-9]+$/) ? $2 : 0}')
  fi

  local ref_color="%F{147}"     # Lavender
  local dirty_color="%F{204}"   # Red
  local ahead_color="%F{216}"   # Peach
  local behind_color="%F{117}"  # Blue
  local reset="%f"

  GIT_PROMPT_CACHE="${ref_color} $ref${reset}"
  [[ -n $dirty ]] && GIT_PROMPT_CACHE+=" ${dirty_color}$dirty${reset}"
  (( ahead > 0 )) && GIT_PROMPT_CACHE+=" ${ahead_color}↑$ahead${reset}"
  (( behind > 0 )) && GIT_PROMPT_CACHE+=" ${behind_color}↓$behind${reset}"
}

set_prompt() {
  PROMPT="%F{110}%~%f${GIT_PROMPT_CACHE:+ $GIT_PROMPT_CACHE} %F{141}❯%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_prompt_info
add-zsh-hook precmd set_prompt

phpserver () {
  local port="${1:-0}"
  php -S "localhost:800$port"
}
alias sv=phpserver

