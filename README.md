# ~/.dotfiles

<!-- markdownlint-disable MD013 -->
![CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?branch=main&label=ci&logo=github)
![License](https://img.shields.io/github/license/jtrrll/dotfiles?label=license&logo=googledocs&logoColor=white)
<!-- markdownlint-enable MD013 -->

My dotfiles collection for configuring frequently used programs.
Managed via [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)

## Usage

1. [Install Nix](https://zero-to-nix.com/start/install)
2. Activate a default configuration by running the following:

   ```sh
   nix-shell \
     -p home-manager \
     --run "home-manager switch -b bak --impure --flake github:jtrrll/dotfiles#default"
   ```

   Alternatively, activate a specific configuration by running the following command.
   Replace `<CONFIG>` with name of a configuration defined in [`flake.nix`](flake.nix):

   ```sh
   nix-shell \
     -p home-manager \
     --run "home-manager switch -b bak --impure --flake github:jtrrll/dotfiles#<CONFIG>"
   ```
