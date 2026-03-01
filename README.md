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

<!-- BEGIN OPTIONS -->
### `dotfiles.ai.enable`

* Default: `true`
* Description: Whether to enable jtrrll's AI configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.ai.packages`

* Default: `[]`
* Description: The set of packages to appear in the AI environment.
* Type: `list of package`

### `dotfiles.browsers.brave.enable`

* Default: `true`
* Description: Whether to enable jtrrll's Brave browser configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.codeDirectory.enable`

* Default: `true`
* Description: Whether to enable jtrrll's code directory configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.editors.indentWidth`

* Default: `2`
* Description: The number of spaces per indent.
* Example: `4`
* Type: `unsigned integer, meaning >=0`

### `dotfiles.editors.lineLengthRulers`

* Default: `[100,120]`
* Description: The columns to place vertical lines on.
* Example: `[80]`
* Type: `list of (unsigned integer, meaning >=0)`

### `dotfiles.editors.linesAroundCursor`

* Default: `8`
* Description: The number of lines to show above and below the cursor.
* Example: `2`
* Type: `unsigned integer, meaning >=0`

### `dotfiles.editors.neovim.enable`

* Default: `true`
* Description: Whether to enable jtrrll's Neovim configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.editors.zed.enable`

* Default: `true`
* Description: Whether to enable jtrrll's Zed configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.gaming.enable`

* Default: `true`
* Description: Whether to enable jtrrll's gaming configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.git.enable`

* Default: `true`
* Description: Whether to enable jtrrll's Git configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.homeManager.enable`

* Default: `true`
* Description: Whether to enable jtrrll's home-manager configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.musicLibrary.enable`

* Default: `true`
* Description: Whether to enable jtrrll's music library configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.nix.enable`

* Default: `true`
* Description: Whether to enable jtrrll's Nix configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.notes.enable`

* Default: `true`
* Description: Whether to enable jtrrll's note taking configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.screensavers.enable`

* Default: `true`
* Description: Whether to enable jtrrll's screensavers.
* Example: `true`
* Type: `boolean`

### `dotfiles.ssh.enable`

* Default: `true`
* Description: Whether to enable jtrrll's SSH configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.terminal.enable`

* Default: `true`
* Description: Whether to enable jtrrll's terminal configuration.
* Example: `true`
* Type: `boolean`

### `dotfiles.theme.backgroundImage`

* Default: `"/home/${config.home.username}/.config/background"`
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
* Description: Whether to enable jtrrll's system-wide theme.
* Example: `true`
* Type: `boolean`

### `dotfiles.windowManager.enable`

* Default: `true`
* Description: Whether to enable jtrrll's window manager configuration.
* Example: `true`
* Type: `boolean`
<!-- END OPTIONS -->
