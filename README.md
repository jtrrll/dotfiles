# ~/.dotfiles
![GitHub Actions CI Status](https://github.com/jacksonterrill/dotfiles/workflows/dotfiles-ci/badge.svg)
![License](https://img.shields.io/github/license/jacksonterrill/dotfiles?labelColor=2E3440&color=ECEFF4&style=flat)

My dotfiles collection for configuring frequently used programs. Managed via [chezmoi](https://www.chezmoi.io/)

These dotfiles were primarily designed for my Wayland Arch Linux system, but should be mostly compatible with other Linux distributions and MacOS

## Usage
To install my dotfiles, simply install [chezmoi](https://www.chezmoi.io/) with any package manager and run the following command:
```sh
$ chezmoi init --apply jacksonterrill
```

Alternatively, install both chezmoi and my dotfiles in one command with the following command:
```sh
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jacksonterrill
```
