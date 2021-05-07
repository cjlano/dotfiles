# vim: ft=zsh
# Derivated from oh-my-zsh Bureau Theme

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="‹%{$fg_bold[green]%}±%{$reset_color%}%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}›"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status () {
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  _STATUS=""
  if $(echo "$_INDEX" | grep '^[AMRD]. ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi
  if $(echo "$_INDEX" | grep '^.[MTD] ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi
  if $(echo "$_INDEX" | grep -E '^\?\? ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$_INDEX" | grep '^UU ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi
  if $(echo "$_INDEX" | grep '^## .*ahead' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | grep '^## .*behind' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | grep '^## .*diverged' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  echo $_STATUS
}

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}


current_path() {
  local _PATH="%~"
  if [[ $# != 0 ]]
  then
    _PATH="%$1<…<%~%<<"
  fi
    echo "%{$fg_bold[blue]%}$_PATH%{$reset_color%}"
}

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}➤"
else
  _USERNAME="%{$fg[green]%}%n"
  _LIBERTY="%{$fg[default]%}➤"
fi
_USERNAME="$_USERNAME%{$fg[cyan]%}@%{$fg[green]%}%m"
_LIBERTY="$_LIBERTY%{$reset_color%}"

str_width() {
  local STR=$1
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  echo $LENGTH
}

get_space () {
  local STR=$1$2
  local LENGTH=$(str_width $STR)
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))
  if [[ $LENGTH -lt 0 ]]; then
      LENGTH=0
  fi

  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}


bureau_precmd () {
  _GIT=$(bureau_git_prompt)
  _1LEFT="╭─$_USERNAME $(current_path)"
  _1RIGHT="$_GIT [%*]"
  if [[ $(str_width "$_1LEFT $_1RIGHT") -gt ${COLUMNS} ]]
  then
    ((PR_PATHLEN=${COLUMNS} - $(str_width "╭─$_USERNAME $_1RIGHT") - 1))
    _1SPACES=" "
    _1LEFT="╭─$_USERNAME $(current_path $PR_PATHLEN)"
  else
    _1SPACES=`get_space $_1LEFT $_1RIGHT`
  fi

#  print 
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

setopt prompt_subst
PROMPT='╰─$_LIBERTY '
RPROMPT='${return_code}'

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd