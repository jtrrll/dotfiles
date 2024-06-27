# ~/.dotfiles

![GitHub Actions CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?logo=github&label=CI&link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Factions%2Fworkflows%2Fci.yaml)
![License](https://img.shields.io/github/license/jtrrll/dotfiles?link=https%3A%2F%2Fgithub.com%2Fjtrrll%2Fdotfiles%2Fblob%2Fmain%2FLICENSE)

My dotfiles collection for configuring frequently used programs. Managed via [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)

## Usage

1. [Install Nix](https://zero-to-nix.com/start/install)
2. Activate a default configuration by running the following:

   ```sh
   nix-shell -p home-manager --run "home-manager switch -b backup --impure --flake github:jtrrll/dotfiles"
   ```

   Alternatively, activate a specific configuration by running the following command. Replace `<CONFIG>` with the name of a configuration defined in [`flake.nix`](flake.nix):

   ```sh
   nix-shell -p home-manager --run "home-manager switch -b backup --impure --flake github:jtrrll/dotfiles#<CONFIG>"
   ```
