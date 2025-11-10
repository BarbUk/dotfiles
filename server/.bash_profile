if [ -n "$BASH_VERSION" ] && [ -n "$PS1" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

export PATH="/usr/local/sbin:$PATH"
