#!/usr/bin/env bash

set -e -o pipefail -o nounset

readonly dotfiles_dir="$HOME/.dotfiles"

ln_params=(
  --symbolic
  --force
  --relative
)

if [[ -n ${XDG_CONFIG_HOME+x} ]]; then
  mapfile -t apps < <(find "$dotfiles_dir/apps" -mindepth 1 -maxdepth 1)
  for app in "${apps[@]}"; do
    target=$(basename "$app")
    if [ -d "$app" ]; then
      if ! [ -L "$XDG_CONFIG_HOME/$target" ]; then
        echo "Installing config for $app in $XDG_CONFIG_HOME/$target"
        if [ -d "$XDG_CONFIG_HOME/$target" ]; then
          rm -ri "${XDG_CONFIG_HOME:?}/${target:?}"
        fi
        ln "${ln_params[@]}" "$app" "$XDG_CONFIG_HOME/$target"
      fi
    else
      if ! [ -L "$HOME/.$target" ]; then
        echo "Installing config for $app in $HOME/.$target"
        ln "${ln_params[@]}" "$app" "$HOME/.$target"
      fi
    fi
  done
fi

# shellcheck disable=2086
ln "${ln_params[@]}" --no-dereference "$dotfiles_dir/modules/bash-it" "$HOME/.bash_it"
cat "$dotfiles_dir/apps/termite/termite.conf" "$dotfiles_dir/apps/termite/termite.light" >"$dotfiles_dir/apps/termite/config"
ln "${ln_params[@]}" "$dotfiles_dir/apps/vim/vimrc.light" "$dotfiles_dir/apps/vim/vimrc.background"
