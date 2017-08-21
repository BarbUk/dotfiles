#!/usr/bin/env bash
[[ $- != *i* ]] && return

export LC_ALL=en_US.UTF-8

unset MAILCHECK
shopt -s checkwinsize
shopt -s histappend
shopt -s cmdhist
shopt -s autocd 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s cdspell 2> /dev/null
CDPATH="."
PROMPT_DIRTRIM=3
bind Space:magic-space
shopt -s globstar 2> /dev/null
shopt -s nocaseglob;
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"
HISTSIZE=50000
HISTFILESIZE=100000
# Don't record some commands
HISTIGNORE="&:[ ]*:exit:history:clear:env:?:??"
HISTTIMEFORMAT='%F %T '
# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"
# Record each line as it gets issued
PROMPT_COMMAND='history -a'

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export GREP_COLOR="1;33"

export GIT_HOSTING='git@github.com'

export LESS='-WiSFRX'
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export EDITOR=vim

# shellcheck disable=1091
source /etc/bash_completion

export BASH_IT="$HOME/.bash_it"
export BASH_IT_THEME='server'
export SCM_CHECK=true
export THEME_SHOW_SUDO=false
export THEME_SHOW_CLOCK=false

# Load Bash It
# shellcheck disable=1090
source "$BASH_IT/bash_it.sh"
# Load z
# shellcheck disable=2034
_Z_OWNER="$USER"
# shellcheck disable=1090
source "$HOME/.modules/z"
# systend helpers
# shellcheck disable=1090
source "$HOME/.systemd_helpers"
export PATH=~/.bin:$PATH:/usr/sbin:/sbin

alias tail='timeout 3600 tail'
alias bzless='timeout 3600 bzless'
alias zless='timeout 3600 zless'
alias top='timeout 3600 top'
alias htop='TERM=screen timeout 3600 htop'

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias bzgrep='bzgrep --color=auto'
alias zgrep='zgrep --color=auto'

# some more ls aliases
alias ll='ls -lha'
alias l='ls -lh'

alias q='exit'
alias s='netstat -tanpu'
alias _="sudo -s"
alias c='clear'
if hash systemctl 2> /dev/null; then
    alias pss='ps --ppid 2 -p 2 --deselect awfo user,pid,ppid,pcpu,pmem,vsz,rss,tty,stat,start,time,cgroup,command:220'
else
    alias pss='ps --ppid 2 -p 2 --deselect awfo user,pid,ppid,pcpu,pmem,vsz,rss,tty,stat,start,time,command:220'
fi

alias meteo='curl -4 http://wttr.in'

alias tmux='tmux -2'

# v - open files in ~/.viminfo
v() {
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
    while read -r line; do
      [ -f "${line/\~/$HOME}" ] && echo "${line/\~/$HOME}"
    done | fzf --select-1 --reverse --inline-info +s \
      --tac --multi --preview 'highlight --force -O ansi -l {} 2> /dev/null | head -200' --query "$*" -1) \
      && vim "${files//\~/$HOME}"
}

log() {
  local cmd log_file
  cmd="command find /var/log/ -type f -name '*log' 2>/dev/null"
  log_file=$(eval "$cmd" | fzf --height 40% --min-height 25 --tac --tiebreak=length,begin,index --reverse --inline-info) && less "$log_file"
}
