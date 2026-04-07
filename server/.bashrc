# shellcheck shell=bash
[[ $- != *i* ]] && return

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# shellcheck disable=2016
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

check_and_source() {
  local file="$1"
  if [ -e "$file" ]; then
    # shellcheck disable=1090
    . "$file"
  fi
}

# Predictable SSH authentication socket location.
_local_ssh_socket="$HOME/.ssh/${USER}_ssh_auth_sock"
if [ -n "$SSH_AUTH_SOCK" ]; then
  if ! [[ -e "$_local_ssh_socket" ]]; then
    ln -sf "$SSH_AUTH_SOCK" "$_local_ssh_socket"
  fi
  export SSH_AUTH_SOCK="$_local_ssh_socket"
fi

PROMPT_COMMAND='history -a'
export PATH=~/.config/bin:$PATH:/usr/sbin:/sbin

# Bash completion
check_and_source /etc/bash_completion
# Load export
check_and_source "$HOME/.config/server/export"
# Load z
_Z_OWNER="$USER"
check_and_source "$HOME/.config/modules/z/z.sh"
check_and_source "$HOME/.config/modules/fz/fz.sh"
# Completion
check_and_source "$HOME/.config/completion"
# Load Bash It
# shellcheck source=modules/bash-it/bash_it.sh
. "$BASH_IT/bash_it.sh"

check_and_source "$HOME/.config/server/alias"
# systemd helpers
check_and_source "$HOME/.config/server/systemd_helpers"
# functions
check_and_source "$HOME/.config/server/functions"
# custom server configuration
check_and_source "$HOME/.config/server/custom"

define_locale
