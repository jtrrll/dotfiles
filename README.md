# ~/.dotfiles

![GitHub Actions CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?branch=main&logo=github&label=CI)
![License](https://img.shields.io/github/license/jtrrll/dotfiles?label=License)

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
