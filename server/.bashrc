#!/usr/bin/env bash
[[ $- != *i* ]] && return

export LC_ALL=en_US.UTF-8

unset MAILCHECK
set -o noclobber
shopt -s checkwinsize
PROMPT_DIRTRIM=2
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
shopt -s autocd
shopt -s dirspell
shopt -s cdspell
CDPATH="."

export HISTTIMEFORMAT="%b %d %R:%S %Y: "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export LESS='-S'
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export EDITOR=vim

source /etc/bash_completion

export BASH_IT="$HOME/.bash_it"
export BASH_IT_THEME='brainy'
export SCM_CHECK=true
export THEME_SHOW_SUDO=false
export THEME_SHOW_CLOCK=false

# Load Bash It
source $BASH_IT/bash_it.sh
# Load z
source "$HOME/.rupaz"

export PATH=~/.bin:$PATH:/usr/sbin:/sbin

alias tail='timeout 3600 tail'
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
alias ss='netstat -tanpu'
alias _="sudo -s"
alias c='clear'

alias meteo='curl -4 http://wttr.in'

alias grep='grep --color=auto'

alias tmux='tmux -2'

export TERM=xterm-256color
