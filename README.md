<p align="center" >
    <img src="img/header.png" alt="dotfiles" title="dotfiles">
</p>

## About

This repository contains files for configuring my Terminal environment and other various macOS settings. See [Github does dotfiles](https://dotfiles.github.io) for more info

## What does it look like

![Screenshot light shell](http://imgur.com/kKpNkPx.png)
![Screenshot dark shell](http://imgur.com/Jw7QkWI.png)

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git

Clone the repository in `~/.dotfiles`:

```bash
git clone https://github.com/barbuk/dotfiles ~/.dotfiles && ~/.dotfiles
```
init the submodules:

```bash
git submodule update --init
```

You can use source bashrc or use install.sh to symlink the files.
