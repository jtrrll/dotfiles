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

### `dotfiles.theme.backgroundImage`

* Default: `~/.config/background`
* Description: The file path of the background image to use.
* Example: `"path/to/background.png"`
* Type: `absolute path`

### `dotfiles.theme.base16Scheme`

* Default: `null`
* Description: A scheme following the base16 standard.
If set, this can be a path to a file, a string of YAML, or an attribute set.
If unset, defaults to a scheme generated from the background image.

* Example: `"path/to/gruvbox-material-dark-medium.yaml"`
* Type: `null or absolute path or strings concatenated with "\n" or (attribute set)`

### `dotfiles.theme.enable`

* Default: `false`
* Description: Whether to enable jtrrll's system-wide theme.
* Example: `true`
* Type: `boolean`
