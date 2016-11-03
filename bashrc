#!/usr/bin/env bash
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
stty stop undef
shopt -s checkwinsize

dotdir="$HOME/.dotfiles"
export PATH="$PATH:$dotdir/bin"

. "$HOME/.rupaz"
. "$HOME/.tokens"

. "$dotdir/export"

. "$BASH_IT/bash_it.sh"

if [ "$(uname)" = "Darwin" ]; then
    . "$dotdir/darwin"
else
    eval "$(dircolors -b)"
    eval "$(rbenv init -)"
    . "$dotdir/keychain"
fi

. "$dotdir/aliases"
. "$dotdir/functions"
. "$dotdir/systemd_helpers"
. "$dotdir/ssh_completion"

PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
export TERM=xterm-256color
