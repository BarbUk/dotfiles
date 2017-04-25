#!/usr/bin/env bash

set -e -o pipefail -o nounset

readonly dotfiles_dir="$HOME/.dotfiles"

if [ "$(uname)" = "Darwin" ]; then
    LN='ln -sf'
    mkdir -p "$HOME"/{.vim,.tmux/plugins}
else
    LN='ln -srf'
    mkdir -p "$HOME"/{.vim,.tmux/plugins,.mpv,.mpd,.ncmpcpp}
    ${LN} "$dotfiles_dir/system/xinitrc" "$HOME/.xinitrc"
    ${LN} "$dotfiles_dir/apps/mpv" "$HOME/.mpv/config"
    ${LN} "$dotfiles_dir/apps/mpd.conf" "$HOME/.mpd/mpd.conf"
    ${LN} "$dotfiles_dir/apps/ncmpcpp" "$HOME/.ncmpcpp/config"
    ${LN} "$dotfiles_dir/apps/compton.conf" "$HOME/.compton.conf"
    ${LN} "$dotfiles_dir/apps/termite.dark" "$HOME/.config/termite/config"
fi

mkdir -p "$HOME"/.config/htop

${LN} "$dotfiles_dir/shell/bashrc" "$HOME/.bashrc"
${LN} "$dotfiles_dir/shell/inputrc" "$HOME/.inputrc"

${LN}n "$dotfiles_dir/modules/bash-it" "$HOME/.bash_it"
${LN} "$dotfiles_dir/modules/z/z.sh" "$HOME/.rupaz"

${LN} "$dotfiles_dir/apps/tmux.conf" "$HOME/.tmux.conf"
${LN} "$dotfiles_dir/apps/vimrc" "$HOME/.vimrc"
${LN} "$dotfiles_dir/apps/vimrc.dark" "$HOME/.vim/vimrc.background"
${LN} "$dotfiles_dir/apps/gitconfig" "$HOME/.gitconfig"
${LN} "$dotfiles_dir/apps/htoprc" "$HOME/.config/htop/htoprc"
${LN} "$dotfiles_dir/apps/toprc" "$HOME/.toprc"
${LN} "$dotfiles_dir/apps/dir_colors" "$HOME/.dir_colors"

${LN} "$dotfiles_dir/modules/tpm" "$HOME/.tmux/plugins/"
