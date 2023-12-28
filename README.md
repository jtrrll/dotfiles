# ~/.dotfiles
![GitHub Actions CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/test.yml?logo=github&label=ci&link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Factions%2Fworkflows%2Ftest.yml)
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
