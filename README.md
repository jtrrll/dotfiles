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
     --packages "home-manager" \
     --run "home-manager switch -b bak --impure --flake github:jtrrll/dotfiles#default"
   ```

   Alternatively, activate a specific configuration by running the following command.
   Replace `<CONFIG>` with name of a configuration defined in [`flake.nix`](flake.nix):

   ```sh
   nix-shell \
     --packages "home-manager" \
     --run "home-manager switch -b bak --impure --flake github:jtrrll/dotfiles#<CONFIG>"
   ```

## Options

<!-- BEGIN OPTIONS -->
### `dotfiles.bat.enable`

* Default: `true`
* Description: Whether to enable `bat`.
* Example: `false`
* Type: `boolean`

### `dotfiles.browser.enable`

* Default: `true`
* Description: Whether to enable the browser configuration.
* Example: `false`
* Type: `boolean`

### `dotfiles.btop.enable`

* Default: `true`
* Description: Whether to enable `btop`.
* Example: `false`
* Type: `boolean`

### `dotfiles.editors.enable`

* Default: `true`
* Description: Whether to enable the editor configurations.
* Example: `false`
* Type: `boolean`

### `dotfiles.editors.indentWidth`

* Default: `2`
* Description: The number of spaces per indent.
* Example: `4`
* Type: `signed integer`

### `dotfiles.editors.lineLengthRulers`

* Default: `[100,120]`
* Description: The columns to place vertical lines on.
* Example: `[80]`
* Type: `list of signed integer`

### `dotfiles.fastfetch.enable`

* Default: `true`
* Description: Whether to enable `fastfetch`.
* Example: `false`
* Type: `boolean`

### `dotfiles.file-system.enable`

* Default: `true`
* Description: Whether to enable the file-system configuration.
* Example: `false`
* Type: `boolean`

### `dotfiles.git.enable`

* Default: `true`
* Description: Whether to enable the Git configuration.
* Example: `false`
* Type: `boolean`

### `dotfiles.home-manager.enable`

* Default: `true`
* Description: Whether to enable `home-manager`.
* Example: `false`
* Type: `boolean`

### `dotfiles.homeDirectory`

* Default: `"/home/${config.dotfiles.username}"`
* Description: The home directory of the user.
* Example: `"/home/username"`
* Type: `absolute path`

### `dotfiles.media.enable`

* Default: `true`
* Description: Whether to enable the media configuration.
* Example: `false`
* Type: `boolean`

### `dotfiles.nix.enable`

* Default: `true`
* Description: Whether to enable the Nix configuration.
* Example: `false`
* Type: `boolean`

### `dotfiles.repeat.enable`

* Default: `true`
* Description: Whether to enable the `repeat` script.
* Example: `false`
* Type: `boolean`

### `dotfiles.screensavers.enable`

* Default: `true`
* Description: Whether to enable screensavers.
* Example: `false`
* Type: `boolean`

### `dotfiles.terminal.enable`

* Default: `true`
* Description: Whether to enable the terminal configuration.
* Example: `false`
* Type: `boolean`

### `dotfiles.theme.backgroundImage`

* Default: `"/home/${config.dotfiles.username}/.config/background"`
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

* Default: `true`
* Description: Whether to enable a configurable system-wide theme.
* Example: `false`
* Type: `boolean`

### `dotfiles.username`

* Description: The name of the user.
* Example: `"username"`
* Type: `string`

<!-- END OPTIONS -->
