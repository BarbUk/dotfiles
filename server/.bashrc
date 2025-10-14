# shellcheck shell=bash
[[ $- != *i* ]] && return

if locale -a | grep -q ^en_US.UTF-8; then
	export LC_ALL=en_US.UTF-8
else
	export LC_ALL=C.UTF-8
fi

check_and_source() {
	local file="$1"
	if [ -e "$file" ]; then
		# shellcheck disable=1090
		. "$file"
	fi
}

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
shopt -s nocaseglob
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
export GREP_COLORS='mt=1;33'

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

export PATH=~/.config/bin:$PATH:/usr/sbin:/sbin

check_and_source /etc/bash_completion

# Path to the bash it configuration
export BASH_IT=$HOME/.config/bash_it
export SCM_GIT_SHOW_DETAILS=true
export THEME_SHOW_RUBY_PROMPT=false
export SCM_CHECK=true
export BASH_IT_COMMAND_DURATION=true
export SCM_GIT_SHOW_CURRENT_USER=true

# Bashit theme
export BASH_IT_THEME='barbuk'

# Load z
_Z_OWNER="$USER"
check_and_source "$HOME/.modules/z"
# Completion
check_and_source "$HOME/.config/completion"
# Load Bash It
# shellcheck source=modules/bash-it/bash_it.sh
. "$BASH_IT/bash_it.sh"

check_and_source "$HOME/.config/alias/server"
# systemd helpers
check_and_source "$HOME/.config/alias/systemd_helpers"
# functions
check_and_source "$HOME/.config/alias/functions"
