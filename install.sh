#!/usr/bin/env bash

set -e -o pipefail -o nounset

readonly dotfiles_dir="$HOME/.dotfiles"

mkdir -p "$HOME/{.vim,.tmux/plugins,.mpv,.mpd,.ncmpcpp}"

ln -sf "$dotfiles_dir/system/xinitrc" "$HOME/.xinitrc"

ln -sf "$dotfiles_dir/shell/bashrc" "$HOME/.bashrc"
ln -sf "$dotfiles_dir/shell/inputrc" "$HOME/.inputrc"

ln -sf "$dotfiles_dir/modules/bash-it" "$HOME/.bash_it"
ln -sf "$dotfiles_dir/modules/z/z.sh" "$HOME/.rupaz"

ln -sf "$dotfiles_dir/apps/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_dir/apps/vimrc" "$HOME/.vimrc"
ln -sf "$dotfiles_dir/apps/vimrc.dark" "$HOME/.vim/vimrc.background"
ln -sf "$dotfiles_dir/apps/termite.dark" "$HOME/.config/termite/config"
ln -sf "$dotfiles_dir/apps/mpv" "$HOME/.mpv/config"
ln -sf "$dotfiles_dir/apps/mpd.conf" "$HOME/.mpd/mpd.conf"
ln -sf "$dotfiles_dir/apps/ncmpcpp" "$HOME/.ncmpcpp/config"
ln -sf "$dotfiles_dir/apps/compton.conf" "$HOME/.compton.conf"
ln -sf "$dotfiles_dir/apps/gitconfig" "$HOME/.gitconfig"

ln -sf "$dotfiles_dir/modules/tpm" "$HOME/.tmux/plugins/"
