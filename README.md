# ~/.dotfiles

<!-- markdownlint-disable MD013 -->
![CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?branch=main&label=ci&logo=github)
![License](https://img.shields.io/github/license/jtrrll/dotfiles?label=license&logo=googledocs&logoColor=white)
<!-- markdownlint-enable MD013 -->

My dotfiles collection for configuring frequently used programs.
Managed via [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)

![Demo](./demo.gif)

## Usage

1. [Install Nix](https://zero-to-nix.com/start/install)
2. Activate a configuration interactively by running the following:

   ```sh
   nix run github:jtrrll/dotfiles home
   ```

## Options

### `programs.bonsai.enable`

* Default: `false`
* Description: Whether to enable a bonsai tree screensaver.
* Example: `true`

### `programs.edit.enable`

* Default: `false`
* Description: Whether to enable edit.
* Example: `true`

### `programs.edit.package`

* Default: `<derivation edit>`
* Description: The edit package to use

### `programs.matrix.enable`

* Default: `false`
* Description: Whether to enable a matrix rain screensaver.
* Example: `true`

### `programs.snekcheck.enable`

* Default: `false`
* Description: Whether to enable snekcheck.
* Example: `true`

### `programs.snekcheck.package`

* Default: `<derivation snekcheck-0.1.0>`
* Description: The snekcheck package to use

### `services.codeDirectory.enable`

* Default: `false`
* Description: Whether to enable a self-updating and self-cleaning directory for source code.
* Example: `true`

### `services.musicLibrary.enable`

* Default: `false`
* Description: Whether to enable a curated music library.
* Example: `true`
