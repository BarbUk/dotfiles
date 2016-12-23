#!/usr/bin/env bash

set -e -o pipefail -o nounset

readonly dotfiles_dir="$HOME/.dotfiles"

ln -sf "$dotfiles_dir/bashrc" "$HOME/.bashrc"
ln -sf "$dotfiles_dir/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_dir/inputrc" "$HOME/.inputrc"

ln -sf "$dotfiles_dir/modules/bash-it" "$HOME/.bash_it"
ln -sf "$dotfiles_dir/modules/z/z.sh" "$HOME/.rupaz"

ln -sf "$dotfiles_dir/vimrc" "$HOME/.vimrc"

mkdir -p "$HOME/.tmux/plugins"
ln -sf "$dotfiles_dir/modules/tpm" "$HOME/.tmux/plugins/"
