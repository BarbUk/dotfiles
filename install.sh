#!/usr/bin/env bash

set -e -o pipefail -o nounset

readonly dotfiles_dir="$HOME/.dotfiles"

ln -sf "$dotfiles_dir/bashrc" "$HOME/.bashrc"
ln -sf "$dotfiles_dir/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_dir/inputrc" "$HOME/.inputrc"

ln -sf "$dotfiles_dir/bash-it" "$HOME/.bash_it"
ln -sf "$dotfiles_dir/z/z.sh" "$HOME/.rupaz"

mkdir -p "$HOME/.tmux/plugins"
ln -sf "$dotfiles_dir/tpm" "$HOME/.tmux/plugins/"
