#!/usr/bin/env bash

set -e -o pipefail -o nounset

readonly dotfiles_dir="$HOME/.dotfiles"

mkdir -p "$HOME/{.vim,.tmux/plugins,.mpv,.mpd,.ncmpcpp}"

ln -srf "$dotfiles_dir/system/xinitrc" "$HOME/.xinitrc"

ln -srf "$dotfiles_dir/shell/bashrc" "$HOME/.bashrc"
ln -srf "$dotfiles_dir/shell/inputrc" "$HOME/.inputrc"

ln -srfn "$dotfiles_dir/modules/bash-it" "$HOME/.bash_it"
ln -srf "$dotfiles_dir/modules/z/z.sh" "$HOME/.rupaz"

ln -srf "$dotfiles_dir/apps/tmux.conf" "$HOME/.tmux.conf"
ln -srf "$dotfiles_dir/apps/vimrc" "$HOME/.vimrc"
ln -srf "$dotfiles_dir/apps/vimrc.dark" "$HOME/.vim/vimrc.background"
ln -srf "$dotfiles_dir/apps/termite.dark" "$HOME/.config/termite/config"
ln -srf "$dotfiles_dir/apps/mpv" "$HOME/.mpv/config"
ln -srf "$dotfiles_dir/apps/mpd.conf" "$HOME/.mpd/mpd.conf"
ln -srf "$dotfiles_dir/apps/ncmpcpp" "$HOME/.ncmpcpp/config"
ln -srf "$dotfiles_dir/apps/compton.conf" "$HOME/.compton.conf"
ln -srf "$dotfiles_dir/apps/gitconfig" "$HOME/.gitconfig"

ln -srf "$dotfiles_dir/modules/tpm" "$HOME/.tmux/plugins/"
