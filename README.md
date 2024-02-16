# ~/.dotfiles
![GitHub Actions Linux CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/linux-ci.yaml?logo=github&label=linux-ci&link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Factions%2Fworkflows%2Flinux-ci.yaml)
![GitHub Actions MacOS CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/macos-ci.yaml?logo=github&label=macos-ci&link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Factions%2Fworkflows%2Fmacos-ci.yaml)
![GitHub Actions Windows CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/windows-ci.yaml?logo=github&label=windows-ci&link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Factions%2Fworkflows%2Fwindows-ci.yaml)
![GitHub Actions Misc CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/misc-ci.yaml?logo=github&label=misc-ci&link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Factions%2Fworkflows%2Fmisc-ci.yaml)
![License](https://img.shields.io/github/license/jtrrll/dotfiles?link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Fblob%2Fmain%2FLICENSE)

My dotfiles collection for configuring frequently used programs. Managed via [chezmoi](https://www.chezmoi.io/)

These dotfiles are primarily designed for my Wayland Arch Linux system, but should be mostly compatible with other Linux distributions and MacOS

## Usage
To install my dotfiles, simply install [chezmoi](https://www.chezmoi.io/) with any package manager and run the following command:
```sh
$ chezmoi init --apply jtrrll
```

Alternatively, install both chezmoi and my dotfiles in one command with the following command:
```sh
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jtrrll
```
