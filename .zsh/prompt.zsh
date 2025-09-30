GIT_PROMPT_CACHE=""

update_git_prompt_info() {
  GIT_PROMPT_CACHE=""
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local ref dirty
  local -i ahead=0 behind=0 added=0 removed=0 new_files=0
  local -i a_ws=0 d_ws=0 a_st=0 d_st=0

  # branch / ref
  ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return

  # dirty flags
  git diff --quiet 2>/dev/null || dirty="*"
  git diff --cached --quiet 2>/dev/null || dirty="$dirty+"

  # upstream ahead/behind
  if git rev-parse --abbrev-ref @{upstream} &>/dev/null; then
    local remote_status
    remote_status=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    behind=$(echo $remote_status | awk '{print ($1 ~ /^[0-9]+$/) ? $1 : 0}')
    ahead=$(echo  $remote_status | awk '{print ($2 ~ /^[0-9]+$/) ? $2 : 0}')
  fi

  # added/removed (unstaged + staged)
  if ! git diff --quiet --ignore-submodules=all -- : 2>/dev/null; then
    a_ws=$(git diff --numstat 2>/dev/null | awk '($1 ~ /^[0-9]+$/){ai+=$1} END{print ai+0}')
    d_ws=$(git diff --numstat 2>/dev/null | awk '($2 ~ /^[0-9]+$/){di+=$2} END{print di+0}')
  fi

  if ! git diff --cached --quiet --ignore-submodules=all -- : 2>/dev/null; then
    a_st=$(git diff --cached --numstat 2>/dev/null | awk '($1 ~ /^[0-9]+$/){ai+=$1} END{print ai+0}')
    d_st=$(git diff --cached --numstat 2>/dev/null | awk '($2 ~ /^[0-9]+$/){di+=$2} END{print di+0}')
  fi

  added=$((a_ws + a_st))
  removed=$((d_ws + d_st))

  # new (untracked) files
  new_files=$(git status --porcelain --untracked-files=normal 2>/dev/null \
    | awk 'substr($0,1,2)=="??"{c++} END{print c+0}')

  # --- catppuccin mocha colors ---
  local ref_color="%F{#b4befe}"     # lavender
  local dirty_color="%F{#f38ba8}"   # red
  local ahead_color="%F{#fab387}"   # peach
  local behind_color="%F{#89b4fa}"  # blue
  local added_color="%F{#a6e3a1}"   # green
  local removed_color="%F{#f38ba8}" # red
  local new_color="%F{#f9e2af}"    # yellow
  local reset="%f"

  GIT_PROMPT_CACHE="${ref_color} $ref${reset}"
  [[ -n $dirty ]] && GIT_PROMPT_CACHE+=" ${dirty_color}$dirty${reset}"
  (( ahead   > 0 )) && GIT_PROMPT_CACHE+=" ${ahead_color}↑$ahead${reset}"
  (( behind  > 0 )) && GIT_PROMPT_CACHE+=" ${behind_color}↓$behind${reset}"
  (( new_files > 0 )) && GIT_PROMPT_CACHE+=" ${new_color}?$new_files${reset}"
  (( added   > 0 )) && GIT_PROMPT_CACHE+=" ${added_color}+$added${reset}"
  (( removed > 0 )) && GIT_PROMPT_CACHE+=" ${removed_color}-$removed${reset}"
}

set_prompt() {
  local hostname_color="%F{#f9e2af}" # yellow
  local path_color="%F{#89b4fa}"     # blue
  local arrow_color="%F{#cba6f7}"    # mauve
  PROMPT="${hostname_color}%m%f ${path_color}%~%f${GIT_PROMPT_CACHE:+ $GIT_PROMPT_CACHE} ${arrow_color}❯%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_prompt_info
add-zsh-hook precmd set_prompt
