git_prompt_info() {
  # Check if we're in a Git repo
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local ref dirty ahead=0 behind=0

  # Get branch or short SHA
  ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return

  # Detect dirty/staged status
  git diff --quiet 2>/dev/null || dirty="*"
  git diff --cached --quiet 2>/dev/null || dirty="${dirty}+"

  # Get ahead/behind
  if git rev-parse --abbrev-ref @{upstream} &>/dev/null; then
    local remote_status
    remote_status=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    behind=$(echo $remote_status | awk '{print ($1 ~ /^[0-9]+$/) ? $1 : 0}')
    ahead=$(echo $remote_status | awk '{print ($2 ~ /^[0-9]+$/) ? $2 : 0}')
  fi

  # Format using Catppuccin Mocha colors
  local ref_color="%F{147}"     # Lavender
  local dirty_color="%F{204}"   # Red
  local ahead_color="%F{216}"   # Peach
  local behind_color="%F{117}"  # Blue
  local reset="%f"

  local output="${ref_color} $ref${reset}"
  [[ -n $dirty ]] && output+=" ${dirty_color}$dirty${reset}"
  [[ "$ahead" -gt 0 ]] && output+=" ${ahead_color}↑$ahead${reset}"
  [[ "$behind" -gt 0 ]] && output+=" ${behind_color}↓$behind${reset}"

  echo "$output"
}

autoload -Uz add-zsh-hook
set_prompt() {
  local git_info="$(git_prompt_info)"
  local space_if_git_info=""
  [[ -n $git_info ]] && space_if_git_info=" $git_info"

  PROMPT="%F{110}%~%f${space_if_git_info} %F{141}❯%f "
}
add-zsh-hook precmd set_prompt

phpserver () {
  local port="${1:-0}"
  php -S "localhost:800$port"
}
alias sv=phpserver

